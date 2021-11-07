//
//  FirebaseStorageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
// import Firebase
// import FirebaseStorage
import RxSwift

protocol StorageImageRepo {
    func uploadImages(postID: String, images: [UIImage], completion: @escaping (Result<[URL?], FirebaseError>) -> Void)
    func updateImages(postID: String, images: [UIImage], completion: @escaping (Result<[URL?], FirebaseError>) -> Void)
    func deleteImages(postID: String, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping (Result<URL?, FirebaseError>) -> Void)
    func updateUserImage(userID: String, image: UIImage?, completion: @escaping (Result<URL?, FirebaseError>) -> Void)
}

class FirebaseStorageRepo: BaseRepository, StorageImageRepo {
    
    var imageURLDB = [
        URL(string: "https://images.unsplash.com/photo-1633534855355-bfe52ee56d75?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
        URL(string: "https://images.unsplash.com/photo-1633534855355-bfe52ee56d75?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
        URL(string: "https://images.unsplash.com/photo-1606818171990-d7dd127e962c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=685&q=80"),
        URL(string: "https://images.unsplash.com/photo-1620878439728-a8f735a95e3f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1287&q=80"),
        URL(string: "https://images.unsplash.com/photo-1620878439728-a8f735a95e3f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1287&q=80")
    ]
    
//    private let postImageStorage = Storage.storage().reference().child("postImage")
//    private let userImageStorage = Storage.storage().reference().child("userImage")
    
    func uploadImages(postID: String, images: [UIImage], completion: @escaping (Result<[URL?], FirebaseError>) -> Void) {
        // 포스트ID가 좋은 식별자 -> 이걸로 저장
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success([]))
        }
    }
    
    func updateImages(postID: String, images: [UIImage], completion: @escaping (Result<[URL?], FirebaseError>) -> Void) {
        // 같은 이름으로 업로드시 자동으로 업데이트
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success([]))
        }
    }
    
    func deleteImages(postID: String, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        // 포스트ID로 삭제
        completion(.success(.deleteImageSuccess))
    }
    
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping (Result<URL?, FirebaseError>) -> Void) {
        // 유저ID 식별자
        
        //        guard let imageData = image?.jpegData(compressionQuality: 0.25) else { return }
        //        let fileName = userID
        //        userImageStorage.child(fileName).putData(imageData, metadata: nil) { _, _ in
        //            self.userImageStorage.child(fileName).downloadURL { url, _ in
        //                completion(url)
        //            }
        //        }
        completion(.success(nil))
    }
    
    func updateUserImage(userID: String, image: UIImage?, completion: @escaping (Result<URL?, FirebaseError>) -> Void) {
        completion(.success(URL(string: "https://images.unsplash.com/photo-1549068106-b024baf5062d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80")))
    }
    
}
