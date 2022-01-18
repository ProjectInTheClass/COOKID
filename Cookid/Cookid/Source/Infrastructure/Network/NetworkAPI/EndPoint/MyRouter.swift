//
//  MyRouter.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation
import Alamofire

enum MyRouter {
    case searchPhoto(String)
}

extension MyRouter: RouterType {
    
    var baseURLString: String {
        return "https://api.unsplash.com"
    }
    
    var headers: HTTPHeaders? {
        return [
            .contentType("application/json; charset=UTF-8"),
            .accept("application/json; charset=UTF-8")
        ]
    }
    
    var path: String {
        switch self {
        case .searchPhoto:
            return "/search/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .searchPhoto:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .searchPhoto(let request):
            return .query(request)
        }
    }

}

