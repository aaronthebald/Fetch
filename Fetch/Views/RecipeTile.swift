//
//  RecipeRow.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import SwiftUI

/// View to display Recipe
struct RecipeTile: View {
    @ObservedObject var vm: HomeViewModel
    let recipe: Recipe
    /// Optional UIImage that is created if the HomeViewModel successfully fetches Image Data.
    @State private var uiImage: UIImage?
    /// If an error is caught when trying to fetch Image Data, property is set to true and a placeholder image is shown.
    @State private var failedToLoad: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage {
                VStack(alignment: .leading) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(alignment: .topTrailing, content: {
                            if linksAvailable() {
                                infoSection
                            }
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
    /// Menu to display links to the **Recipe** YouTube video or Source website.
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
    
    /// Placeholder image in case the image fails to download.
    var failedToLoadImageView: some View {
        VStack(alignment: .leading) {
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .topTrailing, content: {
                    if linksAvailable() {
                        infoSection
                    }
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
    
    /// ## Overview:
    /// Function first attempts to unwrap the photoURLLarge property of **recipe**.
    /// If photoURLLarge is nil, the function attempts to unwrap the photoURLSmall property of **recipe**
    /// When a URL String is unwrapped the **fetchImage(urlString: String)** function is called
    func loadImage() {
        if let urlString = recipe.photoURLLarge {
            fetchImage(urlString: urlString)
        } else {
            if let urlString = recipe.photoURLSmall {
                fetchImage(urlString: urlString)
            }
        }
    }
    
    /// Function attempts to fetch Image Data from the **HomeViewModel**
    /// ## Fail State:
    /// If an error is caught **failedToLoad** is set to true.
    /// - Parameter urlString: The String associated with the image.
    func fetchImage(urlString: String) {
        Task {
            do {
                let data = try await vm.fetchImageData(imageURL: urlString)
                uiImage = UIImage(data: data)
            } catch {
                failedToLoad = true
            }
        }
    }
    
    /// Convenience function to determine if the **Recipe** object passed into the view has a valid photoURL property.
    /// ## Overview:
    /// If the **Recipe** object does not have a valid photoURL , **failedToLoad** is set to true and a value of false is returned.
    /// If the **Recipe** *does* have a valid photoURL then a value of true is returned.
    /// - Returns: Bool
    func photoURLStringsHaveValue() -> Bool {
        if (recipe.photoURLLarge == nil || recipe.photoURLLarge == "") && (recipe.photoURLSmall == nil || recipe.photoURLSmall == "") {
            failedToLoad = true
            return false
        } else {
            return true
        }
    }
    
    /// Convenience function to determine if the **Recipe** object passed into the view has a valid YouTube or Source URL String.
    /// ## Overview:
    /// If the **Recipe** object does not have a valid YouTube or Source URL String a value of false is returned.
    /// If the **Recipe** *does* have a valid YouTube or Source URL String then a value of true is returned.
    /// - Returns: Bool
    func linksAvailable() -> Bool {
       if (recipe.youtubeURL == nil || recipe.youtubeURL == "") && (recipe.sourceURL == nil || recipe.sourceURL == "") {
            return false
       } else {
           return true
       }
    }
}
