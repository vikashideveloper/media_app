//
//  MockNetworkRepository.swift
//  ImageLoaderAppTests
//
//  Created by Vikash Kumar on 15/04/24.
//

import Foundation
@testable import ImageLoaderApp

class MockNetworkRepository: Repository {
    var mediaCoverageResult: Result<[Media], AppError>!
    var downloadImageResult: Result<Data, AppError>!

    func fetchMediaCoverages() async -> Result<[Media], AppError> {
        return mediaCoverageResult
    }
    
    func downloadImage(from url: URL) async -> Result<Data, AppError> {
        guard let data = getImageFromFile() else { return .failure(.imageNotFound)}
        return .success(data as Data)
    }
    
    func fetchMediaFromfile() -> Result<[Media], AppError> {
        let medias = MockMedias.allMedias()
        return .success(medias)
    }
    
    func getImageFromFile() -> NSData?  {
        guard let url = Bundle(for: MockCacheHandler.self).url(forResource: "mock_image2", withExtension: ".jpg") else { return nil }
        let data = NSData(contentsOf: url)
        return data
    }

    
}
