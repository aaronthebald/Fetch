//
//  HomeViewModel.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private let dataService = RecipeDataService()
    
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
}
