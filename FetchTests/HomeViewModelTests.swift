//
//  HomeViewModelTests.swift
//  FetchTests
//
//  Created by Aaron Wilson on 2/18/25.
//

import Testing
@testable import Fetch

struct HomeViewModelTests {

    
    @Test func showAlertIsTrue() async {
        let dataService = RecipeDataService(urlString: Constants.urlStringWithError)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == true)
    }
    
    @Test func showAlertIsFalse() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == false)
    }
    
    @Test func alertMessageIsNotBlank() async {
        let dataService = RecipeDataService(urlString: Constants.urlStringWithError)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage != "")
    }
    
    @Test func alertMessageIsBlank() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage == "")
    }
    
    @Test func recipesAreUpdated() async {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(!vm.recipes.isEmpty)
    }
    
    

}
