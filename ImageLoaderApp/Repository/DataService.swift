//
//  DataService.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import Foundation
import SwiftUI


final class DataService {
    private let repository: Repository
    private let imageCache: CacheRepository
    
    init(repository: Repository, imageCache: CacheRepository) {
        self.repository = repository
        self.imageCache = imageCache
    }
    
    func fetchMediaCoverages() async  -> Result<[Media], AppError>  {
        // from remote
        let result = await repository.fetchMediaCoverages()
        return result
    }
    
    func downloadImage(for media: Media, quality: Int) async -> Result<Data, AppError> {
        let imageKey = "\(media.thumbnail.id).\(quality)"
        if let data = imageCache.getImageDataFromCache(key: imageKey) {
            return .success(data as Data)
        }
        
        let result = await repository.downloadImage(from: media.thumnailUrl()!)
        switch result {
        case .failure(let error):
            return .failure(error)
        case .success(let data):
            imageCache.saveImageInCache(data as NSData, for: imageKey)
            return result
        }
    }
}
