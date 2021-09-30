//
//  FirebaseStorageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
import Firebase
import FirebaseStorage
import RxSwift

class FirebaseStorageRepo {
    static let instance = FirebaseStorageRepo()
    
    private let postImageStorage = Storage.storage().reference().child("postImage")
    
    private let userImageStorage = Storage.storage().reference()
        .child("userImage")
    
    @discardableResult
    func uploadImages(postID: String, images: [UIImage], completion: @escaping (Result<[URL], NetWorkingError>) -> Void) -> Observable<[URL]> {
        return Observable.create { observer in
            observer.onNext([])
            return Disposables.create()
        }
    }
    
    func deleteImages<T: Codable>(postID: String, completion: @escaping (Result<T, NetWorkingError>) -> Void) {
        
    }
    
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping (URL?) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.25) else { return }
        let fileName = userID
        userImageStorage.child(fileName).putData(imageData, metadata: nil) { _, _ in
            self.userImageStorage.child(fileName).downloadURL { url, _ in
                completion(url)
            }
        }
    }
}
