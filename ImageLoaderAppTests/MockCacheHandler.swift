//
//  MockCacheHandler.swift
//  ImageLoaderAppTests
//
//  Created by Vikash Kumar on 15/04/24.
//

import Foundation
@testable import ImageLoaderApp

final class MockCacheHandler: CacheRepository {
    private let memoryCache = NSCache<NSString, AnyObject>()
    var cacheData: NSData?
    var diskData: NSData?
    
    func getImageDataFromCache(key: String) -> NSData? {
        return cacheData ?? diskData
    }
    
    func saveImageInCache(_ data: NSData, for key: String) {
        
    }
    
    func getImageFromInMemory()  {
        guard let url = Bundle(for: MockCacheHandler.self).url(forResource: "mock_image", withExtension: ".jpg") else { return }
        cacheData =  NSData(contentsOf: url)
        diskData = nil
    }

    func getImageFromDiskMemory()  {
        guard let url = Bundle(for: MockCacheHandler.self).url(forResource: "mock_image2", withExtension: ".jpg") else { return }
        diskData = NSData(contentsOf: url)
        cacheData = nil
    }

    
}
