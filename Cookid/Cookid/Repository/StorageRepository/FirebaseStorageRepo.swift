//
//  FirebaseStorageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
import FirebaseStorage

class FirebaseStorageRepo {
    static let instance = FirebaseStorageRepo()
    
    private let postImageStorage = Storage.storage().reference().child("postImage")
    
    func uploadImages(postID: String, images: [UIImage], completion: @escaping (Result<URL?, NetWorkingError>) -> Void) {
        
    }
    
    func deleteImages<T: Codable>(postID: String, completion: @escaping (Result<T, NetWorkingError>) -> Void) {
        
    }
    
}
