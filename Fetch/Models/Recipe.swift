//
//  Recipe.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//
// Example JSON to build the model from. Normally, I would not do this by hand. This is a good example of where AI is useful.
/*
 {
             "cuisine": "Malaysian",
             "name": "Apam Balik",
             "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
             "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
             "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
             "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
             "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
         }
 */

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
