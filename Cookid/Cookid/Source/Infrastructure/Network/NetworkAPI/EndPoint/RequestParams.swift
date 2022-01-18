//
//  RequestParams.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation

enum RequestParams {
    case query(_ parameter: String?)
    case body(_ parameter: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String:Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionary = jsonData as? [String:Any] else { return [:] }
        return dictionary
    }
}
