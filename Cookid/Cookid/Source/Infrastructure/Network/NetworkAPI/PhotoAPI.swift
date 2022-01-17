//
//  PhotoAPI.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/17.
//

import Foundation
import Alamofire
import RxSwift

class PhotoAPI: NetworkAPIType {
    
    func search(_ query: String) -> Observable<[Photo]> {
        return Observable.create { observer in
            SessionManager
                .shared
                .session
                .request(MyRouter.searchPhoto(query))
                .validate(statusCode: 200...300)
                .response { response in
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let response = try decoder.decode(NetworkResponse<Photo>.self, from: response.data!)
                        observer.onNext(response.results)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
