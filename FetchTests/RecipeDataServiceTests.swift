//
//  RecipeDataServiceTests.swift
//  RecipeDataServiceTests
//
//  Created by Aaron Wilson on 2/15/25.
//

import Testing
@testable import Fetch

struct RecipeDataServiceTests {
    
    var dataService = RecipeDataService()
    
    
    @Test func dataServiceReturnsArrayOfRecipe() async throws {
        let returnedData = try await dataService.fetchAllRecipes()
        #expect(!returnedData.isEmpty)
    }
    
    @Test func dataServiceThrowsInvalidResponseError() async throws {
        dataService.testingStatus = .returnError
        await #expect(throws: RecipeDataService.RecipeDataServiceErrors.invalidResponseCode, performing: {
            let _ = try await dataService.fetchAllRecipes()
        })
    }
    
    @Test func dataServiceThrowsFailedToCreateError() async throws {
        
        dataService.testingStatus = .returnInvalidURL
        
        #expect(throws: RecipeDataService.RecipeDataServiceErrors.failedToCreateURL, performing: {
            try dataService.getAllRecipesURL()
        })
        
    }
    
    @Test func dataServiceGetImageDataReturnsData() async throws {
        dataService.testingStatus = .functional
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg"
        
        let data = try await dataService.getImageData(imageURL: urlString)
        
        #expect(data != nil)
    }
    
    @Test func dataServiceGetImageDataThrowsBadURLError() async throws {
        dataService.testingStatus = .functional
        let urlString = ""
        
        await #expect(throws: RecipeDataService.RecipeDataServiceErrors.failedToCreateURL, performing: {
            try await dataService.getImageData(imageURL: urlString)

        })
    }

}
