//
//  RecipeDataService.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class RecipeDataService: RecipeDataServiceProtocol {
    
    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let jsonDecoder = JSONDecoder()
    
    func getAllRecipesURL() throws -> URL {
        guard let url = URL(string: urlString) else {
            print("Failed to create url from urlString: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
    
    func fetchAllRecipes() async throws -> [Recipe] {
        
        do {
            let url = try getAllRecipesURL()
            let (data, responseCode) = try await URLSession.shared.data(from: url)
            
            guard (responseCode as? HTTPURLResponse)?.statusCode == 200 else {
                print("The response code from the server was invalid")
                throw RecipeDataServiceErrors.invalidResponseCode
            }
            
            let returnedData = try jsonDecoder.decode(RecipesAPIResponse.self, from: data)
            
            return returnedData.recipes
        } catch {
            throw error
        }
        
    }
    
    enum RecipeDataServiceErrors: Error {
        case failedToCreateURL
        case invalidResponseCode
    }
    
}
