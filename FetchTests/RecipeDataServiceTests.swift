//
//  RecipeDataServiceTests.swift
//  RecipeDataServiceTests
//
//  Created by Aaron Wilson on 2/15/25.
//

import Testing
@testable import Fetch

struct RecipeDataServiceTests {
    
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that the returned data is not empty.
    @Test func dataServiceReturnsArrayOfRecipe() async throws {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let returnedData = try await dataService.fetchAllRecipes()
        #expect(!returnedData.isEmpty)
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an error.
    /// Tests that when the invalid response code is received, the function throws **RecipeDataServiceErrors.invalidResponseCode**.
    @Test func dataServiceThrowsInvalidResponseError() async throws {
        let dataService = RecipeDataService(urlString: Constants.urlStringWithError)
        await #expect(throws: RecipeDataServiceErrors.invalidResponseCode, performing: {
            let _ = try await dataService.fetchAllRecipes()
        })
    }
    /// Creates RecipeDataService with a URL String that cannot be used to create a URL.
    /// Tests that when the URL cannot be created,  **RecipeDataServiceErrors.failedToCreateURL** is thrown.
    @Test func dataServiceThrowsFailedToCreateError() async throws {
        let dataService = RecipeDataService(urlString: Constants.cannotCreateURLString)
        #expect(throws: RecipeDataServiceErrors.failedToCreateURL, performing: {
            try dataService.getAllRecipesURL()
        })
        
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that when the  **getImageData** function is called with a valid String, the data returned is not equal is nil.
    @Test func dataServiceGetImageDataReturnsData() async throws {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)

        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg"
        
        let data = try await dataService.getImageData(imageURL: urlString)
        
        #expect(data != nil)
    }
    
    /// Creates RecipeDataService with a URL String to an endpoint that will return an array of Recipe.
    /// Tests that when the the **getImageData** function is called and a blank String is passed into the function, **RecipeDataServiceErrors.failedToCreateURL** is thrown.
    @Test func dataServiceGetImageDataThrowsBadURLError() async throws {
        let dataService = RecipeDataService(urlString: Constants.functionalURLString)
        let urlString = ""
        
        await #expect(throws: RecipeDataServiceErrors.failedToCreateURL, performing: {
            try await dataService.getImageData(imageURL: urlString)

        })
    }

}
