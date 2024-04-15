//
//  ImageLoaderAppTests.swift
//  ImageLoaderAppTests
//
//  Created by Vikash Kumar on 14/04/24.
//

import XCTest
import SwiftUI
@testable import ImageLoaderApp

final class ImageLoaderAppTests: XCTestCase {
    private var service: DataService?
    private var cacheHandler: MockCacheHandler?
    private var networkRepository: MockNetworkRepository?
    private var viewModel: MediaCoverageListViewModel?
    
    @MainActor override func setUpWithError() throws {
        cacheHandler = MockCacheHandler()
        networkRepository = MockNetworkRepository()
        service = DataService(repository: networkRepository!, imageCache: cacheHandler!)
        viewModel = MediaCoverageListViewModel(dataService: service!)
    }

    override func tearDownWithError() throws {
        cacheHandler = nil
        networkRepository = nil
        service = nil
        viewModel = nil
    }

    @MainActor func test_if_CoverageMediaLoadedFromRemote() async throws {
        networkRepository?.mediaCoverageResult = networkRepository?.fetchMediaFromfile()
        await viewModel?.fetchMediaCoverages()
        XCTAssertEqual(viewModel?.medias.count, 10) // mock file size is 95330
    }

    func test_if_image_loaded_from_disk() async throws {
        cacheHandler?.getImageFromDiskMemory()
        networkRepository?.downloadImageResult = .success(cacheHandler!.diskData! as Data)
        let result = await viewModel?.downloadImageFor(media: MockMedias.validMedia()!)
        XCTAssertEqual(result?.count, 95330) // mock file size is 95330
    }
    
    func test_if_image_loaded_from_inMemory() async throws {
        cacheHandler?.getImageFromInMemory()
        networkRepository?.downloadImageResult = .success(cacheHandler!.cacheData! as Data)
        let result = await viewModel?.downloadImageFor(media: MockMedias.validMedia()!)
        XCTAssertEqual(result?.count, 12088) // mock file size is 12088
    }

    func test_if_image_loaded_from_Network() async throws {
        cacheHandler?.cacheData = nil
        cacheHandler?.diskData = nil
        let result = await viewModel?.downloadImageFor(media: MockMedias.validMedia()!)
        XCTAssertEqual(result?.count, 95330) // mock file size is 12088
    }
}
