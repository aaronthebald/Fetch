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
    @State var data: Data?
    @State var uiImage: UIImage?
    @State var failedToLoad: Bool = false
    
    var body: some View {
        if let uiImage {
            VStack(alignment: .leading) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(alignment: .topLeading) {
                        Text(recipe.cuisine)
                            .padding(4)
                            .background {
                                Rectangle()
                                    .fill(Material.thin)
                                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 0, style: .continuous))
                                
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                infoSection
            }
        } else if failedToLoad {
            VStack(alignment: .leading) {
                Image(systemName: "photo.badge.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(alignment: .topLeading) {
                        Text(recipe.cuisine)
                            .padding(4)
                            .background {
                                Rectangle()
                                    .fill(Material.thin)
                                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 0, style: .continuous))
                                
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                infoSection
            }
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }

}

#Preview {
    RecipeTile(vm: HomeViewModel(dataService: RecipeDataService(), cacheService: CacheService()), recipe: Recipe(cuisine: "American", name: "Banana Pancakes", id: UUID().uuidString, photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg", photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg", sourceURL: "https://www.bbcgoodfood.com/recipes/banana-pancakes", youtubeURL: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"), data: nil)
}

extension RecipeTile {
    var infoSection: some View {
        HStack(alignment: .top) {
            Text(recipe.name)
            Spacer()
#warning("These need to be implemented safely!")
            if let youtubeURL = recipe.youtubeURL {
                Link(destination: URL(string: youtubeURL)!) {
                    Image(systemName: "play.tv")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)

            }
#warning("These need to be implemented safely!")
            if let sourceURL = recipe.sourceURL {
                Link(destination: URL(string: sourceURL)!) {
                    Image(systemName: "globe")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .font(.title)
    }
    
    func loadImage() {
        Task  {
            do {
                let data = try await vm.fetchImageData(imageURL:  recipe.photoURLLarge ?? "", name: recipe.name)
                uiImage = UIImage(data: data)
            } catch {
                failedToLoad = true
            }
        }
    }
}
