//
//  PostCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class PostCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    
    let userService: UserService
    let commentService: CommentService
    let postService: PostService
    let mealService: MealService
    let shoppingService: ShoppingService
    
    init(parentCoordinator : CoordinatorType, userService: UserService, commentService: CommentService, postService: PostService, mealService: MealService, shoppingService: ShoppingService) {
        self.parentCoordinator = parentCoordinator
        self.userService = userService
        self.commentService = commentService
        self.postService = postService
        self.mealService = mealService
        self.shoppingService = shoppingService
    }
    
    func start() -> UIViewController {
        var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
        postMainVC.bind(viewModel: PostViewModel(postService: postService, userService: userService, commentService: commentService, mealService: mealService, shoppingService: shoppingService))
        postMainVC.coordinator = self
        navigationController = UINavigationController(rootViewController: postMainVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateRankingVC(viewModel: PostViewModel) {
        let rankingViewModel = RankingViewModel(userService: viewModel.userService)
        var vc = RankingMainViewController()
        vc.bind(viewModel: rankingViewModel)
        vc.modalPresentationStyle = .automatic
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateSignInVC(viewModel: PostViewModel) {
        var signInVC = SignInViewController.instantiate(storyboardID: "UserInfo")
        signInVC.bind(viewModel: viewModel)
        signInVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(signInVC, animated: true)
    }
    
    func navigateAddPostVC(viewModel: PostViewModel, senderTag: Int) {
        let addPostVC = AddPostViewController.instantiate(storyboardID: "Post")
        addPostVC.reactor = AddPostReactor(postService: postService, userService: userService)
        navigationController?.pushViewController(addPostVC, animated: true)
        
        switch senderTag {
        case 1:
            print("바버튼 누르기")
        case 2:
            print("글 올리기")
        case 3:
            print("사진 올리기")
        default:
            break
        }
    }
    
    func navigateCommentVC(post: Post, comments: [Comment], commentService: CommentService) {
        let commentVC = CommentViewController()
        commentVC.reactor = CommentReactor(post: post, commentService: commentService, userService: userService)
        commentVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
