//
//  HomeViewModelTests.swift
//  FetchTests
//
//  Created by Aaron Wilson on 2/18/25.
//

import Testing
@testable import Fetch

struct HomeViewModelTests {

    let dataService = RecipeDataService()
    
    @Test func showAlertIsTrue() async {
        dataService.testingStatus = .returnError
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == true)
    }
    
    @Test func showAlertIsFalse() async {
        dataService.testingStatus = .functional
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.showAlert == false)
    }
    
    @Test func alertMessageIsNotBlank() async {
        dataService.testingStatus = .returnError
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage != "")
    }
    
    @Test func alertMessageIsBlank() async {
        dataService.testingStatus = .functional
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(vm.alertMessage == "")
    }
    
    @Test func recipesAreUpdated() async {
        dataService.testingStatus = .functional
        let vm = HomeViewModel(dataService: dataService, cacheService: CacheService())
        await vm.fetchRecipes()
        #expect(!vm.recipes.isEmpty)
    }
    
    

}
