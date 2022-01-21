//
//  MyInterceptor.swift
//  SwinjectTest
//
//  Created by 박형석 on 2022/01/13.
//

import Foundation
import Alamofire

final class MyInterceptor: RequestInterceptor {
    
    // session에서 request를 호출할 때 같이 호출된다.
    // 중간에 가로채서 조정을 좀 한 뒤 다시.. 보낸다.
    // request를 받아서 request를 리턴. 즉, request 조정을 할 수 있다.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("MyInterceptor - adapt")
        
        var request = urlRequest
        let commonParams = [
            "client_id":"Qi4G9qPq4OGMycRtl3aHLlZNmCO99slGa3C9MDkj6rU"
        ]
        
        do {
            request = try URLEncodedFormParameterEncoder().encode(commonParams, into: request)
        } catch {
            print(NetworkError.adaptError)
        }
        
        completion(.success(request))
    }
    
    // Request에서 Error가 발생했을 때, 재시도할 수 있는 기능을 제공한다.
    // validate 설정해줘야 이 메소드를 호출한다.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("MyInterceptor - retry")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("statusCode"), object: statusCode)
        completion(.doNotRetry)
    }
    
}
