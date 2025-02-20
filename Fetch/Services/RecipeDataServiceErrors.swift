//
//  RecipeDataServiceErrors.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/20/25.
//
import Foundation

enum RecipeDataServiceErrors: Error {
    case failedToCreateURL
    case invalidResponseCode
}

extension RecipeDataServiceErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToCreateURL:
            return NSLocalizedString("Failed to create URL", comment: "failedToCreateURL")
        case .invalidResponseCode:
            return NSLocalizedString("There seems to be an issue with the server", comment: "response code")
        }
    }
}
