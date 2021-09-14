//
//  PostMainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import Kingfisher

class PostMainViewController: UIViewController, ViewModelBindable, StoryboardBased {

    // MARK: - UIComponents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rankingButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postButtonWithCaption: UIButton!
    @IBOutlet weak var postButtonWithCamera: UIButton!
    
    // MARK: - Properties
    var viewModel: PostViewModel!
    var coordinator: HomeCoordinator?
    
    // MARK: - View LC
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthRepo.instance.isSignIn { result in
            switch result {
            case .success(.successSignIn) :
                print("success")
            case .failure(let error) :
                print(error)
                self.coordinator?.navigateSignInVC(viewModel: self.viewModel)
            default :
                print("error")
            }
        }
    }
    
    // MARK: - Functions
    private func configureUI() {
        userImage.makeCircleView()
        postButtonWithCaption.layer.cornerRadius = 10
        postButtonWithCamera.layer.cornerRadius = 10
    }
    
    // MARK: - bindViewModel
    func bindViewModel() {
        
        viewModel.output.posts
            .bind(to: tableView.rx.items(cellIdentifier: "postCell", cellType: PostTableViewCell.self)) { _, item, cell in
                cell.updateUI(post: item, user: DummyData.shared.singleUser, commentCount: 2)
            }
            .disposed(by: rx.disposeBag)
        
        rankingButton.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateRankingVC(viewModel: self.viewModel)
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.userService.user()
            .bind { [unowned self] user in
                userImage.kf.setImage(with: user.image, placeholder: UIImage(named: IMAGENAME.placeholder))
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCaption.rx.tap
            .bind { [unowned self] in
                print("postButtonWithCaption")
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCamera.rx.tap
            .bind { [unowned self] in
                print("postButtonWithCamera")
            }
            .disposed(by: rx.disposeBag)
    }

}
