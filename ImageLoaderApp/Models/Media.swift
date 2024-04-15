//
//  Media.swift
//  ImageLoaderApp
//
//  Created by Vikash Kumar on 14/04/24.
//

import Foundation

struct Media: Identifiable, Decodable {
    let id: String
    let title: String
    let thumbnail: Thumbnail
    
    func thumnailUrl(with quality: Int = 20) -> URL? {
        return URL(string: thumbnail.thumnailPath(with: quality).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")
    }
}

extension Media: Hashable {
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct Thumbnail: Decodable {
    let id: String
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    
    func thumnailPath(with quality: Int = 20) -> String {
        let urlString = "\(domain)/\(basePath)/\(quality)/\(key)"
        return urlString
    }
}
