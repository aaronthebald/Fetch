//
//  RecipeDataService.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class RecipeDataService: RecipeDataServiceProtocol {
    
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    private let jsonDecoder = JSONDecoder()
    
    func fetchAllRecipes() async throws -> [Recipe] {
        
        do {
            let url = try getAllRecipesURL()
            let (data, responseCode) = try await URLSession.shared.data(from: url)
            
            guard
                let status = (responseCode as? HTTPURLResponse)?.statusCode,
                status >= 200 && status < 300 else {
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
            
            guard
                let status = (responseCode as? HTTPURLResponse)?.statusCode,
                status >= 200 && status < 300 else {
                print("The response code from the server was invalid")
                throw RecipeDataServiceErrors.invalidResponseCode
            }
            return data
        } catch {
            throw error
        }
    }
    
    internal func getAllRecipesURL() throws -> URL {
        guard let url = URL(string: urlString) else {
            print("Failed to create url from urlString: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
    
    internal func getImageURL(imageURL: String) throws -> URL {
        guard let url = URL(string: imageURL) else {
            print("Failed to create url from imageURL: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
}
