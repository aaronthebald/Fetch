//
//  HomeViewModel.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

/// ObservableObject that manages the **HomeView**
class HomeViewModel: ObservableObject {
    
    /// The array of Recipes to be displayed in the app.
    @Published private(set) var recipes: [Recipe] = []
    
    /// If set to true, an alert is shown to notify the user of an error. Can then be set to false by the user to dismiss the alert.
    @Published var showAlert: Bool = false
    
    /// String describing the error received to user.
    @Published private(set) var alertMessage: String = ""
   
    /// If the received array of Recipes is empty, property is set to true, updating the view to inform the user no Recipes were found.
    @Published private(set) var showEmptyResultsView: Bool = false
    
    /// Initializer for the HomeViewModel class
    /// - Parameters:
    ///   - dataService: Object that conforms to the RecipeDataService protocol
    ///   - cacheService: Object that conforms to the CacheService protocol
    init(dataService: RecipeDataServiceProtocol, cacheService: CacheServiceProtocol) {
        self.dataService = dataService
        self.cacheService = cacheService
    }
    
    /// Object to manage fetching data from the API
    private let dataService: RecipeDataServiceProtocol
    
    /// Object to manage fetching and saving Image data to the Cache
    private let cacheService: CacheServiceProtocol
    
    /// ## Overview:
    /// Function attempts to fetch an array of Recipe objects from the dataService.
    /// If successful, the MainActor is awaited,  the  **recipes** property is updated to reflect the contents of the returnedRecipes.
    /// ## Fail State
    /// If the returnedRecipes object is an empty array, then the **showEmptyResultsView** property is set to true.
    /// If an error is caught then the MainActor is awaited and the **alertMessage** property is set to the localized description of the error and the **showAlert** property is set to true.
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
    
    /// Function for retrieving Image data
    /// ##  Overview:
    /// Function will attempt to fetch image data from the **cacheService** using the imageURL as the key value.
    /// If the data is not found in the cache, then the function will attempt to fetch it from the **dataService** using the imageURL.
    /// If the data is fetched successfully, then the data is saved to the cache using the imageURL string as it's key value.
    /// Then the data that has been fetched from the **dataService** is returned.
    ///
    /// ## Fail State:
    /// If the function caught an error from the **dataService** while attempting to fetch the image data, the caught error is thrown.
    /// - Parameters:
    ///   - imageURL: The URL String associated with the Image
    /// - Returns: Data to be used to create a UIImage
    func fetchImageData(imageURL: String) async throws -> Data {
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
