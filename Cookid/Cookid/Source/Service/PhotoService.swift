//
//  PhotoService.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/21.
//

import Foundation
import RxSwift

protocol PhotoServiceType {
    func fetchPhotos(query: String) -> Observable<[Photo]>
}

class PhotoService: BaseService, PhotoServiceType {
    func fetchPhotos(query: String) -> Observable<[Photo]> {
        return Observable<[Photo]>.create { observer in
//            self.repoProvider.afUnsplashRepo.performRequest(with: endPoint) { result in
//                switch result {
//                case .success(_):
//                    print("success")
//                case .failure(let error):
//                    print(error)
//                }
//            }
            return Disposables.create()
        }
    }
}
