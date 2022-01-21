//
//  RouterType.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation
import Alamofire

/// should implement func asURLRequest() throws -> URLRequest
protocol RouterType: URLRequestConvertible {
    var baseURLString: String { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var httpMethod: HTTPMethod { get }
    var parameters: RequestParams { get }
}

extension RouterType {
    
    /// Alamofire URLRequestConvertible extension method
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.baseURLString) else {
            throw NetworkError.componentRequest
        }
        
        guard var urlRequest = try? URLRequest(url: url.appendingPathComponent(self.path), method: self.httpMethod, headers: self.headers) else {
            throw NetworkError.componentRequest
        }
        
        switch self.parameters {
        case .query(let request):
            let params: [String:String?] = ["query":request]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
            // 이 작업도 URLEncodedFormParameterEncoder 사용해서 할 수 있음
            // URLEncodedFormParameterEncoder 사용
//            let paramsDic = [
//                "query":"request의 스트링"
//            ]
//            urlRequest = try URLEncodedFormParameterEncoder().encode(paramsDic, into: urlRequest)
            
        case .body(let request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}
