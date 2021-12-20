//
//  SessionManagerType.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation
import Alamofire

protocol SessionManagerType {
    typealias RequestModifier = (inout URLRequest) throws -> Void
    
    func request(_ convertible: URLConvertible,
                      method: HTTPMethod,
                      parameters: Parameters?,
                      encoding: ParameterEncoding,
                      headers: HTTPHeaders?,
                      interceptor: RequestInterceptor?,
                      requestModifier: RequestModifier?) -> DataRequest
}

extension Session: SessionManagerType {
    
}
