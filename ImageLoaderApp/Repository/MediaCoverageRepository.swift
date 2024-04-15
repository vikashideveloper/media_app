//
//  MediaCoverageRepository.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import Foundation

protocol Repository {
    func fetchMediaCoverages() async -> Result<[Media], AppError>
    func downloadImage(from url: URL) async -> Result<Data, AppError>
}

final class MediaCoverageRepository: Repository {
    
    func fetchMediaCoverages() async -> Result<[Media], AppError> {
        //fetch data from remote
        let limit = 100
        guard let url = URL(string: API.getMediaCoverages(limit).endPoint) else { return .failure(AppError.badUrl)}
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let _ = json as? [[String : Any]]  {
                let medias = try JSONDecoder().decode([Media].self, from: data)
                return .success(medias)
            } else if let errorJson = json as? [String : Any],
                      let error = AppError.handleError(from: errorJson) {
                return .failure(error)
            } else {
                return .failure(.unexpected)
            }
        } catch {
            return .failure(AppError.handleError(error as NSError))
        }
    }
    
    func downloadImage(from url: URL) async -> Result<Data, AppError> {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return .success(data)
        } catch {
            return .failure(AppError.handleError(error as NSError))
        }
        
    }
}

extension MediaCoverageRepository {
    private enum API {
        private var domain: String { Utilities.infoForKey("BASE_URL")}
        
        case getMediaCoverages(Int)
        
        var endPoint: String {
            switch self {
            case .getMediaCoverages(let limit):
                return domain + "content/misc/media-coverages?limit=\(limit)"
            }
        }
    }
}
