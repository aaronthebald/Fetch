//
//  RecipeRow.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/17/25.
//

import SwiftUI

struct RecipeRow: View {
    @ObservedObject var vm: HomeViewModel
    let recipe: Recipe
    @State var data: Data?
    @State var uiImage: UIImage?
    @State var failedToLoad: Bool = false

    var body: some View {
        if let uiImage {
            HStack(alignment: .bottom) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                Spacer()
                VStack(alignment: .leading) {
                    Text(recipe.name)
                    Text(recipe.cuisine)
                }
            }
            .padding(.horizontal, 4)
            .frame(height: 100)
        } else if failedToLoad {
            HStack(alignment: .bottom) {
                Image(systemName: "photo.badge.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack(alignment: .leading) {
                    Text(recipe.name)
                    Text(recipe.cuisine)
                }
            }
            .frame(height: 100)
        } else {
            HStack(alignment: .bottom) {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
                Spacer()
                VStack(alignment: .leading) {
                    Text(recipe.name)
                    Text(recipe.cuisine)
                }
            }
            .padding(.horizontal, 4)
            .frame(height: 100)
            
        }
    }
    
    func loadImage() {
        Task  {
            do {
                let data = try await vm.fetchImageData(imageURL:  recipe.photoURLLarge ?? "", name: recipe.name)
                uiImage = UIImage(data: data)
            } catch {
                print("does the catch block run?")
                failedToLoad = true
            }
        }
    }
}

#Preview {
    RecipeRow(vm: HomeViewModel(dataService: RecipeDataService(), cacheService: CacheService()), recipe: Recipe(cuisine: "American", name: "Banana Pancakes", id: UUID().uuidString, photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg", photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg", sourceURL: "https://www.bbcgoodfood.com/recipes/banana-pancakes", youtubeURL: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"), data: nil)
}
