//
//  Photo.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

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

struct NetworkResponse<Wrapper: Codable>: Codable {
    var results: [Wrapper]
}

struct PhotoImageURL: Codable {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "regular"
    }
}

struct Photographer: Codable {
    let name: String
    let image: ProfileImageURL
    
    enum CodingKeys: String, CodingKey {
        case name
        case image = "profile_image"
    }
}

struct ProfileImageURL: Codable {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "medium"
    }
}


