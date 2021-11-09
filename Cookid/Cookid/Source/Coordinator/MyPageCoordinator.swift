//
//  MyPageCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class MyPageCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    var serviceProvider: ServiceProviderType
    
    init(parentCoordinator : CoordinatorType, serviceProvider: ServiceProviderType) {
        self.parentCoordinator = parentCoordinator
        self.serviceProvider = serviceProvider
    }
    
    func start() -> UIViewController {
        var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
        myPageVC.coordinator = self
        myPageVC.bind(viewModel: MyPageViewModel(serviceProvider: serviceProvider))
        navigationController = UINavigationController(rootViewController: myPageVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateUserInfoVC(viewModel: MyPageViewModel) {
        var userInfoVC = UpdateUserInfoViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: viewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(userInfoVC, animated: true, completion: nil)
    }
    
    func presentEditActionSheet(reactor: MyPostReactor, post: Post) {
        let alertVC = UIAlertController(title: "내 포스팅 관리", message: "해당 게시물을 수정하거나 삭제하고 싶으시면 아래 버튼을 눌러주세요.\n삭제시 복구가 불가능합니다. 유념해 주세요:)", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            reactor.action.onNext(.deletePost(post))
        }
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            let addPostVC = AddPostViewController.instantiate(storyboardID: "Post")
            let reactor = AddPostReactor(mode: .edit(post), serviceProvider: self.serviceProvider)
            addPostVC.reactor = reactor
            self.navigationController?.pushViewController(addPostVC, animated: true)
            YPImagePickerManager.shared.pickingImages(viewController: addPostVC) { images in
                reactor.action.onNext(.imageUpload(images))
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(deleteAction)
        alertVC.addAction(updateAction)
        alertVC.addAction(cancelAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
 
}
