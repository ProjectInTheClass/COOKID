//
//  PostMainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Kingfisher
import NaverThirdPartyLogin

class PostMainViewController: UIViewController, ViewModelBindable, StoryboardBased {

    // MARK: - UIComponents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rankingButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postButtonWithCaption: UIButton!
    @IBOutlet weak var postButtonWithCamera: UIButton!
    @IBOutlet weak var addPostBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    var viewModel: PostViewModel!
    var coordinator: PostCoordinator?
    var expandedIndexSet: IndexSet = []
    
    // MARK: - View LC
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        AuthRepo.instance.isSignIn { result in
//            switch result {
//            case .success(.successSignIn) :
//                print("success")
//            case .failure(let error) :
//                print(error)
//                self.coordinator?.navigateSignInVC(viewModel: self.viewModel)
//            default :
//                print("error")
//            }
//        }
    }
    
    // MARK: - Functions
    private func configureUI() {
        userImage.makeCircleView()
        postButtonWithCaption.layer.cornerRadius = 10
        postButtonWithCamera.layer.cornerRadius = 10
        addPostBarButton.tag = 1
        postButtonWithCaption.tag = 2
        postButtonWithCamera.tag = 3
    }
    
    // MARK: - bindViewModel
    func bindViewModel() {
        
        viewModel.output.user
            .bind { [unowned self] user in
                self.userImage.image = user.image
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.postCellViewModel
            .bind(to: tableView.rx.items(cellIdentifier: "postCell", cellType: PostTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.coordinator = self.coordinator
                cell.updateUI(viewModel: item)
                
                if self.expandedIndexSet.contains(index) {
                    cell.postCaptionLabel.numberOfLines = 0
                    cell.detailButton.isHidden = true
                } else {
                    cell.postCaptionLabel.numberOfLines = 2
                    cell.detailButton.isHidden = false
                }
                
                cell.detailButton.rx.tap
                    .bind(onNext: {
                        if self.expandedIndexSet.contains(index) {
                            self.expandedIndexSet.remove(index)
                        } else {
                            self.expandedIndexSet.insert(index)
                        }
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: rx.disposeBag)
        
        rankingButton.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateRankingVC(viewModel: self.viewModel)
            }
            .disposed(by: rx.disposeBag)
        
        addPostBarButton.rx.tap
            .bind { [unowned self] in
                coordinator?.navigateAddPostVC(viewModel: self.viewModel, senderTag: self.addPostBarButton.tag)
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCaption.rx.tap
            .bind { [unowned self] in
                coordinator?.navigateAddPostVC(viewModel: self.viewModel, senderTag: self.postButtonWithCaption.tag)
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCamera.rx.tap
            .bind { [unowned self] in
                coordinator?.navigateAddPostVC(viewModel: self.viewModel, senderTag: self.postButtonWithCamera.tag)
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
}

extension PostMainViewController: UIScrollViewDelegate, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 36 {
            self.addPostBarButton.tintColor = .black
            self.addPostBarButton.isEnabled = true
        } else {
            self.addPostBarButton.tintColor = .clear
            self.addPostBarButton.isEnabled = false
        }
    }
}
