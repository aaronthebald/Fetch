//
//  RecipeDataService.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

/// This class handles fetching data from the API
class RecipeDataService: RecipeDataServiceProtocol {
    
    /// API endpoint that **fetchAllRecipes()** will attempt to download from.
    let urlString: String
    
    /// Initializer for RecipeDataService class
    /// - Parameter urlString: This String will be used to create the URL from which the *fetchAllRecipes()* function will attempt to fetch data.
    init(urlString: String) {
        self.urlString = urlString
    }
    
    private let jsonDecoder = JSONDecoder()
    
    ///  Function to fetch recipe data from API
    ///  ## Overview
    /// Function will attempt to create a URL with the urlString passed into the class during initialization using the *getAllRecipesURL()* function.
    /// Function insures that the response code from the server is between 200-299.
    /// Function then uses the instance of JSONDecoder to decode the returned data into a **RecipesAPIResponse** model.
    /// Function then returns the **RecipesAPIResponse.recipes**  property.
    /// - Returns: [Recipe].
    /// - Throws: RecipeDataServiceErrors.invalidResponseCode, JSON decoding error.
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
    
    /// Function to fetch Image Data from API
    /// ## Overview:
    /// Function will attempt to create URL using the **getImageURL()** function.
    /// Function insures that the response code from the server is between 200-299.
    /// If the response code is valid, the received data is returned.
    /// - Parameter imageURL: URL String of Image Data
    /// - Returns: Data
    /// - Throws: RecipeDataServiceErrors.invalidResponseCode
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
    
    /// Function attempts to create URL from the urlString property of the RecipeDataService class
    /// - Returns: URL
    /// - Throws: RecipeDataServiceErrors.failedToCreateURL
    internal func getAllRecipesURL() throws -> URL {
        guard let url = URL(string: urlString) else {
            print("Failed to create url from urlString: \(urlString)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
    
    /// Function attempts to create URL from the imageURL String passed in.
    /// - Returns: URL
    /// - Throws: RecipeDataServiceErrors.failedToCreateURL
    internal func getImageURL(imageURL: String) throws -> URL {
        guard let url = URL(string: imageURL) else {
            print("Failed to create url from imageURL: \(imageURL)")
            throw RecipeDataServiceErrors.failedToCreateURL
        }
        return url
    }
}
