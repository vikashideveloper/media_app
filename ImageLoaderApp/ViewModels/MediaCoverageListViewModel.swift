//
//  MediaCoverageListViewModel.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import SwiftUI

@MainActor
final class MediaCoverageListViewModel: ObservableObject {
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    @Published var medias = [Media]()
    @Published var error: AppError?
    @Published var isLoading = false
    
    func clearError() {
        error = nil
    }
    
    func fetchMediaCoverages() async {
        clearError()
        isLoading = true
        let result = await dataService.fetchMediaCoverages()
        isLoading = false
        switch result {
        case .success(let medias):
            self.medias = medias
        case .failure(let error):
            self.error = error
        }
    }
    
    func downloadImageFor(media: Media, quality: Int = 20) async -> Data? {
        let result = await dataService.downloadImage(for: media, quality: quality)
        switch result {
        case .success(let data):
            return data
        case .failure:
            return nil
        }
    }
}

extension MediaCoverageListViewModel {
    static func instantiateWithDI() -> MediaCoverageListViewModel {
        let repository = MediaCoverageRepository()
        let imageCache = CacheHandler()
        let service = DataService(repository: repository, imageCache: imageCache)
        return MediaCoverageListViewModel(dataService: service)
    }
}
