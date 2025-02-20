//
//  HomeViewModel.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published var showAlert: Bool = false
    @Published private(set) var alertMessage: String = ""
    @Published private(set) var showEmptyResultsView: Bool = false
    
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
                if returnedRecipes.isEmpty {
                    showEmptyResultsView = true
                } else {
                    recipes = returnedRecipes
                }
            }
        } catch  {
            await MainActor.run {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    func fetchImageData(imageURL: String, name: String) async throws -> Data {
        guard let data = cacheService.getImage(imageURL: imageURL) else {
            do {
                let data = try await dataService.getImageData(imageURL: imageURL)
                cacheService.addImage(imageData: NSData(data: data), imageURL: imageURL)
                return data
            } catch {
                throw error
            }
        }
        return Data(data)
    }
    
}
