//
//  PhotoEntity.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

struct PhotoEntity: Codable {
    let url: URL?
    let timeStamp: Int
}

extension PhotoEntity: Comparable {
    static func < (lhs: PhotoEntity, rhs: PhotoEntity) -> Bool {
        return lhs.timeStamp < rhs.timeStamp
    }
}
