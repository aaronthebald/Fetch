//
//  CacheService.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import Foundation

protocol CacheServiceProtocol {
    var imageCache: NSCache<NSString, NSData> { get set }
    func addImage(imageData: NSData, imageURL: String)
    func getImage(imageURL: String) -> NSData?
}

class CacheService: ObservableObject, CacheServiceProtocol {
    
    deinit {
        imageCache.removeAllObjects()
    }
    
    var imageCache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
         cache.countLimit = 50
         cache.totalCostLimit = 1024 * 1024 * 100
         return cache
    }()
    
    func addImage(imageData: NSData, imageURL: String) {
        imageCache.setObject(imageData, forKey: imageURL as NSString)
    }
    
    func getImage(imageURL: String) -> NSData? {
        if let data = imageCache.object(forKey: imageURL as NSString) {
            return data
        }
        return nil
    }
}
