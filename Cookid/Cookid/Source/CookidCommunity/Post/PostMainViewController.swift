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
import ReactorKit

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
        setRefresh()
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
    
    private func setRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "최신 글 가져오기")
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        viewModel.input.fetchFreshPosts.accept(())
        tableView.refreshControl?.endRefreshing()
    }
    
    func footerIndicator() -> UIView {
        let indicator = UIActivityIndicatorView()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        footerView.backgroundColor = .systemBackground
        indicator.startAnimating()
        footerView.addSubview(indicator)
        indicator.center = footerView.center
        return footerView
    }

    // MARK: - bindViewModel
    func bindViewModel() {
        
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
        
        tableView.rx.contentOffset
            .withUnretained(self)
            .filter { owner, offset in
                // frame이 0으로 세팅되는 초기값 filtering
                print(offset)
                guard owner.tableView.frame.height > 0 else { return false }
                // 1: 테이블뷰의 크기 + offset(아래로 탐색하는 거리)
                // 2: 테이블뷰 내부 셀들의 합
                // 전체 컨텐츠 탐색을 완료하기 100 전에 로딩하기
                return offset.y + owner.tableView.frame.height >= owner.tableView.contentSize.height - 200
            }
            .map { _ in }
            .bind(to: viewModel.input.fetchPastPosts)
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
        
        viewModel.output.user
            .withUnretained(self)
            .bind { owner, user in
                owner.userImage.setImageWithKf(url: user.image)
                owner.viewModel.serviceProvider.postService.fetchLastPosts(currentUser: user, completion: { _ in })
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.isLoading
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, isLoading in
                if isLoading {
                    owner.tableView.tableFooterView = owner.footerIndicator()
                } else {
                    owner.tableView.tableFooterView = nil
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.fetchInitialDate()
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
