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
import Then
import SnapKit

class PostMainViewController: UIViewController, ViewModelBindable, StoryboardBased {

    // MARK: - UIComponents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rankingButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postButtonWithCaption: UIButton!
    @IBOutlet weak var postButtonWithCamera: UIButton!
    @IBOutlet weak var addPostBarButton: UIBarButtonItem!
    
    private var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    // MARK: - Properties
    var viewModel: PostViewModel!
    var coordinator: PostCoordinator?
    var expandedIndexSet: IndexSet = []
    
    let naverAuthRepo = NaverAutoRepo.shared
    let kakaoAuthRepo = KakaoAuthRepo.shared
    let appleAuthRepo = AppleAuthRepo.shared
    
    // MARK: - View LC
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        makeConstraints()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kakaoAuthRepo.isSignIn { [weak self] success in
            guard let self = self else { return }
            if success {
                print("Kakao Login success")
            } else if self.naverAuthRepo.isSignIn {
                print("Naver Login success")
            } else {
                self.appleAuthRepo.isSignIn { success in
                    if success {
                        print("Apple Login success")
                    } else {
                        self.coordinator?.navigateSignInVC(viewModel: self.viewModel)
                    }
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func settingViewModel() {
        self.naverAuthRepo.viewModel = viewModel
        self.kakaoAuthRepo.viewModel = viewModel
        self.appleAuthRepo.viewModel = viewModel
    }
    
    private func configureUI() {
        userImage.makeCircleView()
        postButtonWithCaption.layer.cornerRadius = 10
        postButtonWithCamera.layer.cornerRadius = 10
        addPostBarButton.tag = 1
        postButtonWithCaption.tag = 2
        postButtonWithCamera.tag = 3
        activityIndicator.startAnimating()
    }
    
    private func makeConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }

    // MARK: - bindViewModel
    func bindViewModel() {
        
        viewModel.output.user
            .bind { [unowned self] user in
                self.userImage.setImageWithKf(url: user.image)
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.posts
            .bind(to: tableView.rx.items(cellIdentifier: "postCell",
                                         cellType: PostTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.coordinator = self.coordinator
                let cellReactor = PostCellReactor(sender: self, post: item, serviceProvider: self.viewModel.serviceProvider)
                cell.reactor = cellReactor
                
                self.updateTableViewCell(cell: cell, index: index)
                
                cell.detailButton.rx.tap
                    .bind(onNext: {
                        if self.expandedIndexSet.contains(index) {
                            self.expandedIndexSet.remove(index)
                        } else {
                            self.expandedIndexSet.insert(index)
                        }
                        UIView.setAnimationsEnabled(false)
                        self.tableView.beginUpdates()
                        self.updateTableViewCell(cell: cell, index: index)
                        self.tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    })
                    .disposed(by: cell.disposeBag)
                
                cellReactor.state.map { $0.isError }
                .bind { isError in
                    if isError {
                        errorAlert(selfView: self, errorMessage: "네트워크 작업에 실패했습니다\n다시 시도해 주세요", completion: {})
                    }
                }
                .disposed(by: cell.disposeBag)
                
                self.activityIndicator.stopAnimating()
            }
            .disposed(by: rx.disposeBag)
        
        rankingButton.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateRankingVC(viewModel: self.viewModel)
            }
            .disposed(by: rx.disposeBag)
        
        addPostBarButton.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateAddPostVC(mode: .new, senderTag: self.addPostBarButton.tag)
                expandedIndexSet = []
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCaption.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateAddPostVC(mode: .new, senderTag: self.postButtonWithCaption.tag)
                expandedIndexSet = []
            }
            .disposed(by: rx.disposeBag)
        
        postButtonWithCamera.rx.tap
            .bind { [unowned self] in
                self.coordinator?.navigateAddPostVC(mode: .new, senderTag: self.postButtonWithCamera.tag)
                expandedIndexSet = []
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    func updateTableViewCell(cell: PostTableViewCell, index: Int) {
        if self.expandedIndexSet.contains(index) {
            cell.postCaptionLabel.numberOfLines = 0
        } else {
            cell.postCaptionLabel.numberOfLines = 2
        }
        
        cell.postCaptionLabel.sizeToFit()
        
        if cell.postCaptionLabel.isTruncated {
            cell.detailButton.isHidden = false
        } else {
            cell.detailButton.isHidden = true
        }
    }
}

extension PostMainViewController: UIScrollViewDelegate, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 25 {
            self.addPostBarButton.tintColor = .black
            self.addPostBarButton.isEnabled = true
        } else {
            self.addPostBarButton.tintColor = .clear
            self.addPostBarButton.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height
    }
}
