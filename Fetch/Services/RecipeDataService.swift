//
//  RecipeDataService.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class RecipeDataService: RecipeDataServiceProtocol {
    private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let urlStringWithError = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-"
    private let urlStringWithEmptyResults = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    private let jsonDecoder = JSONDecoder()
    
    var testingStatus: TestingStatus = .functional
    
    
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
    
    func getImageData(imageURL: String) async throws -> Data {
        do {
            let url = try getImageURL(imageURL: imageURL)
            let (data, responseCode) = try await URLSession.shared.data(from: url)
            guard (responseCode as? HTTPURLResponse)?.statusCode == 200 else {
                print("The response code from the server was invalid")
                throw RecipeDataServiceErrors.invalidResponseCode
            }
            return data
        } catch {
            throw error
        }
    }
    
    func getAllRecipesURL() throws -> URL {
        let urlString = getAllRecipesURLString()
        guard let url = URL(string: urlString) else {
            print("Failed to create url from urlString: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
    
    func getImageURL(imageURL: String) throws -> URL {
        let urlString = getImageURLString(urlString: imageURL)
        guard let url = URL(string: urlString) else {
            print("Failed to create url from imageURL: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
    
    func getAllRecipesURLString() -> String {
        switch testingStatus {
        case .functional:
            return urlString
        case .returnError:
            return urlStringWithError
        case .returnEmpty:
            return urlStringWithEmptyResults
        case .returnInvalidURL:
            return ""
        }
    }
    
    func getImageURLString(urlString: String) -> String {
        switch testingStatus {
        case .functional:
            return urlString
        case .returnError:
            return urlString
        case .returnEmpty:
            return urlString
        case .returnInvalidURL:
            return ""
        }
    }
    
    enum RecipeDataServiceErrors: Error {
        case failedToCreateURL
        case invalidResponseCode
    }
    
    enum TestingStatus {
        case functional
        case returnError
        case returnEmpty
        case returnInvalidURL
    }
    
}
