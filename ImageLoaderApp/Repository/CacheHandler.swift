//
//  CacheHandler.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import Foundation

protocol CacheRepository {
    func getImageDataFromCache(key: String) -> NSData?
    func saveImageInCache(_ data: NSData, for key: String)
}

final class CacheHandler: CacheRepository {
    private let memoryCache = NSCache<NSString, AnyObject>()
    private let fileManager = FileManager()
    
    init() {
        // The maximum number of objects the cache should hold
        memoryCache.countLimit = 10
    }
    
    func getImageDataFromCache(key: String) -> NSData? {
        if let data = getObjectFromInMemory(key: key) {
            return data
        }
        if let data = getObjectFromDisk(key: key as String) {
            saveObjectInMemory(data as NSData, for: key as NSString)
            return data
        }
        return nil
    }
    
    func saveImageInCache(_ data: NSData, for key: String) {
        saveObjectInMemory(data, for: key as NSString)
        saveObjectInDisk(data, for: key)
    }
    
}

extension CacheHandler {
    private func saveObjectInMemory(_ data: NSData, for key: NSString) {
        memoryCache.setObject(data, forKey: key)
    }
    
    private func getObjectFromInMemory(key: String) -> NSData? {
        if let data = memoryCache.object(forKey: key as NSString) as? Data {
            return data as NSData
        }
        return nil
    }
    
    private func saveObjectInDisk(_ data: NSData, for key: String) {
        do {
            let directoryPath = cacheDirectoryPath()
            try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            let filePath = "\(directoryPath)/\(key)"
            fileManager.createFile(atPath: filePath, contents: data as Data, attributes: nil)
            
        } catch {
        }
    }
    
    private func getObjectFromDisk(key: String) -> NSData? {
        let directoryPath = cacheDirectoryPath()
        let filePath = "\(directoryPath)/\(key)"
        if let data = fileManager.contents(atPath: filePath) {
            return data as NSData
        }
        return nil
    }
    
    private func cacheDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let directoryPath = "\(paths.first!)/images"
        return directoryPath
    }
}
