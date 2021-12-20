//
//  EndPoint.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation
import Alamofire

struct Endpoint<R>: ResponRequestable {
    typealias Response = R
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String : String]?
    var sampleData: Data?
}
