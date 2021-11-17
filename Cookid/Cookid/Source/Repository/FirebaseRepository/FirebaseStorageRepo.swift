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
}

class FirebaseStorageRepo: BaseRepository, StorageImageRepo {
    
    private let postImageStorage = Storage.storage().reference().child("postImage")
    private let userImageStorage = Storage.storage().reference().child("userImage")
    
    func uploadImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult) {
        // 포스트ID를 식별자 -> 이걸로 저장
        let dispatchGroup = DispatchGroup()
        var urls = [URL?]()
        for (index, image) in images.enumerated() {
            dispatchGroup.enter()
            let fileName = postID + "\(index)"
            guard let imageData = image.jpegData(compressionQuality: 0.25) else { return }
            postImageStorage.child(fileName).putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(.imagesUploadError))
                    print("fail to upload post Images to storage \(error)")
                } else {
                    self.postImageStorage.child(fileName).downloadURL { url, _ in
                        urls.append(url)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .global()) {
            completion(.success(urls))
        }
    }
    
    func deleteImages(postID: String, completion: @escaping FirebaseResult) {
        // 해당 포스트ID에 해당하는 모든 이미지 삭제
        let dispatchGroup = DispatchGroup()
        for index in 0...2 {
            dispatchGroup.enter()
            let fileName = postID + "\(index)"
            postImageStorage.child(fileName).delete { error in
                if let error = error {
                    // 이미지를 발견하지 못하는 경우의 에러 + @
                    dispatchGroup.leave()
                    print("cannot found post image \(error)")
                } else {
                    // 이미지가 존재하면 삭제
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .global()) {
            completion(.success(.deleteImageSuccess))
        }
    }
    
    func updateImages(postID: String, images: [UIImage], completion: @escaping PostImagesResult) {
        // 해당하는 모든 이미지를 삭제한 후에 다시 업로드
        self.deleteImages(postID: postID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                    print("delete post Images \(success)")
                self.uploadImages(postID: postID, images: images) { result in
                    switch result {
                    case .success(let urls):
                        completion(.success(urls))
                    case .failure(let error):
                        print("cannot upload post Images \(error)")
                    }
                }
            case .failure(let error):
                print("cannot delete post Images \(error)")
            }
        }
    }
    
    func uploadUserImage(userID: String, image: UIImage?, completion: @escaping UserImageResult) {
        // 유저ID 식별자
        // upload시 update가 가능하기 때문에 동시에 사용
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
}
