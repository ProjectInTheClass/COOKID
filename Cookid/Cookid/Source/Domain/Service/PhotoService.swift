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

class PhotoService: PhotoServiceType {
    
    let photoAPI: NetworkAPIType
    init(photoAPI: NetworkAPIType) {
        self.photoAPI = photoAPI
    }
    
    func fetchPhotos(query: String) -> Observable<[Photo]> {
        return self.photoAPI.search(query)
    }
}
