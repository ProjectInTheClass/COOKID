//
//  PostService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation
import RxSwift

class PostService {
    
    private var posts = [Post]()
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    func createPost() {
        
    }
}
