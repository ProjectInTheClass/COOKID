//
//  Photo.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

struct NetworkResponse<Wrapper: Codable>: Codable {
    var results: [Wrapper]
}

struct Photo: Codable {
    let image: PhotoImageURL
    let photographer: Photographer
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case image = "urls"
        case photographer = "user"
        case timestamp = "created_at"
    }
}

struct PhotoImageURL: Codable {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "regular"
    }
}

