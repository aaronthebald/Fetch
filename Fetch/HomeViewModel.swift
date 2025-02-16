//
//  HomeViewModel.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    init(dataService: RecipeDataServiceProtocol, cacheService: CacheServiceProtocol) {
        self.dataService = dataService
        self.cacheService = cacheService
    }
    
    private let dataService: RecipeDataServiceProtocol
    
    private let cacheService: CacheServiceProtocol
    
    func fetchRecipes() async {
        do {
            let returnedRecipes = try await dataService.fetchAllRecipes()
            await MainActor.run {
                recipes = returnedRecipes
            }
        } catch  {
            print(error)
        }
    }
    
    func fetchImageData(imageURL: String, name: String) async throws -> Data {
        guard let data = cacheService.getImage(imageURL: imageURL) else {
            do {
                print("Downloading image for \(name)")
                let data = try await dataService.getImageData(imageURL: imageURL)
                cacheService.addImage(imageData: NSData(data: data), imageURL: imageURL)
                return data
            } catch {
                throw error
            }
        }
        print("data for \(name) was in the cache")
        return Data(data)
    }
    
}
