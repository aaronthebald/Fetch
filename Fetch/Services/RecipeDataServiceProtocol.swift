//
//  RecipeDataServiceProtocol.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

protocol RecipeDataServiceProtocol {
    func fetchAllRecipes() async throws -> [Recipe]
    func getAllRecipesURL() throws -> URL
    func getImageData(imageURL: String) async throws -> Data
    func getImageURL(imageURL: String) throws -> URL
}
