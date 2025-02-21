//
//  HomeViewModelTests.swift
//  FetchTests
//
//  Created by Aaron Wilson on 2/18/25.
//

import Testing
@testable import Fetch

struct HomeViewModelTests {

    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an error.
    /// Tests that when the error is received, the **showAlert** property of the HomeViewModel is set to true.
    @Test func showAlertIsTrue() async {
        let dataService = RecipeDataService(urlString: Constants.urlStringWithError)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == true)
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that when no error is received, the **showAlert** property of the HomeViewModel remains false.
    @Test func showAlertIsFalse() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == false)
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an error.
    /// Tests that when the error is received, the **alertMessage** property of the HomeViewModel is not equal to a blank String.
    @Test func alertMessageIsNotBlank() async {
        let dataService = RecipeDataService(urlString: Constants.urlStringWithError)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage != "")
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that when no error is received, the **alertMessage** property of the HomeViewModel remains a blank String.
    @Test func alertMessageIsBlank() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage == "")
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that when the Recipes are received from the API, the **recipes** property of the HomeViewModel is not empty.
    @Test func recipesAreUpdated() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(!vm.recipes.isEmpty)
    }
    
    

}
