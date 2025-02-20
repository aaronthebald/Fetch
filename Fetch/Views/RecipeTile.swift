//
//  RecipeRow.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import SwiftUI

struct RecipeTile: View {
    @ObservedObject var vm: HomeViewModel
    let recipe: Recipe
    @State private var uiImage: UIImage?
    @State private var failedToLoad: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage {
                VStack(alignment: .leading) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(alignment: .topTrailing, content: {
                            infoSection
                        })
                        .overlay(alignment: .topLeading) {
                            recipeCuisine
                        }
                        .overlay(alignment: .bottomLeading, content: {
                            recipeName
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else if failedToLoad {
                failedToLoadImageView
            } else {
                ProgressView()
                    .onAppear {
                        if photoURLStringsHaveValue() {
                            loadImage()
                        }
                    }
            }
        }
        
    }
    
}

#Preview {
    RecipeTile(vm: HomeViewModel(dataService: RecipeDataService(urlString: Constants.functionalURLString), cacheService: CacheService()), recipe: Recipe(cuisine: "American", name: "Banana Pancakes", id: UUID().uuidString, photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg", photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg", sourceURL: "https://www.bbcgoodfood.com/recipes/banana-pancakes", youtubeURL: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"))
}

extension RecipeTile {
    var infoSection: some View {
        Menu {
            if let youtubeURL = recipe.youtubeURL,
               let url = URL(string: youtubeURL) {
                Link(destination: url) {
                    HStack {
                        Text("YouTube")
                        Image(systemName: "play.tv")
                            .foregroundStyle(.red)
                    }
                    
                }
                .buttonStyle(.plain)
                
            }
            
            if let sourceURL = recipe.sourceURL,
               let url = URL(string: sourceURL) {
                Link(destination: url) {
                    HStack {
                        Text("Source")
                        Image(systemName: "globe")
                            .foregroundStyle(.red)
                    }
                }
                .buttonStyle(.plain)
            }
        } label: {
            Image(systemName: "info.circle")
        }
        .font(.title2)
        .padding(4)
        .background {
            Rectangle()
                .fill(Material.thin)
                .clipShape(.rect(bottomLeadingRadius: 10, style: .continuous))
            
        }
        
    }
    
    var failedToLoadImageView: some View {
        VStack(alignment: .leading) {
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .topTrailing, content: {
                    infoSection
                })
                .overlay(alignment: .topLeading) {
                    recipeCuisine
                }
                .overlay(alignment: .bottomLeading, content: {
                    recipeName
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
    }
    
    var recipeName: some View {
        Text(recipe.name)
            .padding(4)
            .background {
                Rectangle()
                    .fill(Material.thin)
                    .clipShape(.rect(topTrailingRadius: 10, style: .continuous))
                
            }
    }
    
    var recipeCuisine: some View {
        Text(recipe.cuisine)
            .padding(4)
            .background {
                Rectangle()
                    .fill(Material.thin)
                    .clipShape(.rect(bottomTrailingRadius: 10, style: .continuous))
            }
    }
    
    func loadImage() {
        if let urlString = recipe.photoURLLarge {
            fetchImage(urlString: urlString)
        } else {
            if let urlString = recipe.photoURLSmall {
                fetchImage(urlString: urlString)
            }
        }
    }
    
    func fetchImage(urlString: String) {
        Task {
            do {
                let data = try await vm.fetchImageData(imageURL: urlString, name: recipe.name)
                uiImage = UIImage(data: data)
            } catch {
                failedToLoad = true
            }
        }
    }
    
    func photoURLStringsHaveValue() -> Bool {
        if (recipe.photoURLLarge == nil || recipe.photoURLLarge == "") && (recipe.photoURLSmall == nil || recipe.photoURLSmall == "") {
            failedToLoad = true
            return false
        } else {
            return true
        }
    }
}
