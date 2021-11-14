//
//  FirebaseStorageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
import FirebaseStorage
import FirebaseStorageSwift

typealias UserImageResult = (Result<URL?, FirebaseError>) -> Void
typealias PostImagesResult = (Result<[URL?], FirebaseError>) -> Void

protocol StorageImageRepo {
    func uploadImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult)
    func updateImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult)
    func deleteImages(postID: String, completion: @escaping FirebaseResult)
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping UserImageResult)
    func updateUserImage(userID: String, image: UIImage?, completion: @escaping UserImageResult)
}

class FirebaseStorageRepo: BaseRepository, StorageImageRepo {
    
    private let postImageStorage = Storage.storage().reference().child("postImage")
    private let userImageStorage = Storage.storage().reference().child("userImage")
    
    func uploadImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult) {
        // 포스트ID가 좋은 식별자 -> 이걸로 저장
    }
    
    func updateImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult) {
        // 같은 이름으로 업로드시 자동으로 업데이트
    }
    
    func deleteImages(postID: String, completion: @escaping FirebaseResult) {
        // 해당 포스트ID에 해당하는 모든 이미지 삭제
    }
    
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping UserImageResult) {
        // 유저ID 식별자
        guard let imageData = image?.jpegData(compressionQuality: 0.25) else { return }
        let fileName = userID
        userImageStorage.child(fileName).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(.imagesUploadError))
                print("fail to upload user Image to storage \(error)")
            } else {
                self.userImageStorage.child(fileName).downloadURL { url, _ in
                    completion(.success(url))
                }
            }
        }
    }
    
    func updateUserImage(userID: String, image: UIImage?, completion: @escaping UserImageResult) {
        
    }
    
}
