//
//  Errors.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import Foundation

enum AppError: Error {
    case badUrl
    case noInternet
    case imageNotFound
    case serverError(String)
    case unexpected
    
    static func handleError(from json: [String : Any]) -> AppError? {
        if let error = json["error"] as? String {
            return .serverError(error)
        }
        return nil
    }
    
    static func handleError(_ error: NSError) -> AppError {
        switch error.code {
        case -1009:
            return .noInternet
        default:
            return .serverError(error.description)
        }
    }
}

extension AppError {
    public var description: String {
        switch self {
        case .badUrl:
            return "The specified url is not valid."
        case .noInternet:
            return "The Internet connection appears to be offline."
        case .imageNotFound:
            return "The requested image is not found"
        case .unexpected:
            return "An unexpected error occurred"
        case .serverError(let message):
            return message
        }
    }
}
