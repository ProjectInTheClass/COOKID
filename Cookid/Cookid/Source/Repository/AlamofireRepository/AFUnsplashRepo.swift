//
//  AFUnsplashRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import Foundation

class AFUnsplashRepo: AlamofireRepositoryType {
    
    let sessionManager: SessionManagerType
    init(sessionManager: SessionManagerType) {
        self.sessionManager = sessionManager
    }
    
    // Request를 실행하는 AFUnsplashRepo에서 Response의 타입을 알아야 제네릭을 적용할 수 있다.
    // 여기서 Endpoint인스턴스 하나만 넘기면 따로 Response타입을 넘기지 않아도 되게끔 설계
    func performRequest<R: Decodable, E: ResponRequestable>(with endPoint: E, completion: @escaping (Result<[R], NetworkError>) -> Void) where E.Response == R {
        let newPhotos = [
            PhotoEntity(url: nil, timeStamp: 123),
            PhotoEntity(url: nil, timeStamp: 123)
        ].sorted(by: >)
        
        
        
    }
    
}
