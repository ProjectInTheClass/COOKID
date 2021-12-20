//
//  Requestable.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
    var sampleData: Data? { get }
}

extension Requestable {
    func urlRequest() throws -> URLRequest {
        let url = try url()
        let urlRequest = try URLRequest(url: url, method: method, headers: nil)
        return urlRequest
    }
    
    func url() throws -> URL {
        let fullPath = "\(baseURL)\(path)"
        guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkError.componentRequest }
        
        // (baseURL + path) + queryParameters
        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = try queryParameters as? [String:Any] {
            queryParameters.forEach {
                urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw NetworkError.componentRequest }
        return url
    }
}
