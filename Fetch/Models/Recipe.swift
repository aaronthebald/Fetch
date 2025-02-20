//
//  Recipe.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation


/// The Main Recipe object to be displayed in the app
///
struct Recipe: Identifiable, Codable {
    
    let cuisine: String
    let name: String
    let id: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case id = "uuid"
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
}
