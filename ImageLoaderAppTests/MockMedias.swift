//
//  MockMedias.swift
//  ImageLoaderAppTests
//
//  Created by Vikash Kumar on 15/04/24.
//

import Foundation
@testable import ImageLoaderApp

class MockMedias {
    static func validMedia() -> Media? {
        let json = [
            "id": "coverage-64b130",
            "title": "From IIM to Monkhood: How an IIT-IIM alumnus found spiritual fulfillment",
            "language": "english",
            "thumbnail": [
              "id": "img-3f66bfcc-4a56-41f7-b24f-23e4d5402e43",
              "version": 1,
              "domain": "https://cimg.acharyaprashant.org",
              "basePath": "images/img-3f66bfcc-4a56-41f7-b24f-23e4d5402e43",
              "key": "image.jpg",
              "qualities": [
                10,
                20,
                30,
                40
              ],
              "aspectRatio": 1
            ],
            "mediaType": 0,
            "coverageURL": "https://www.indiatoday.in/education-today/news/story/from-iim-to-monkhood-how-an-iit-iim-alumnus-found-spiritual-fulfillment-acharya-prashant-2508011-2024-02-28",
            "publishedAt": "2024-02-28",
            "publishedBy": "India Today"
        ] as [String : Any]
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            let media = try JSONDecoder().decode(Media.self, from: data)
            return media
        } catch {
            return nil
        }
    }
    
    static func allMedias() -> [Media] {
        do {
            guard let url = Bundle(for: MockMedias.self).url(forResource: "MockResponse", withExtension: "json") else { return []}
            let data = NSData(contentsOf: url)
            let medias = try JSONDecoder().decode([Media].self, from: data! as Data)
            return medias
        } catch {
            return []
        }

    }
}
