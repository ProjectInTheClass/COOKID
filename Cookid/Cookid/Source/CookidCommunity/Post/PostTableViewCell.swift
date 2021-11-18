//
//  PostTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class PostTableViewCell: UITableViewCell, View {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var budgetCheckImage: UIImageView!
    @IBOutlet weak var budgetCheckLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    
    @IBOutlet weak var starSlider: StarSlider!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var heartButton: HeartButton!
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentListButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    
    var coordinator: PostCoordinator?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: PostCellReactor) {
        
        // MARK: - Reactor Binding
        
        // 포스트에서 변경되지 않는 값
        reactor.state.map { $0.post }
        .withUnretained(self)
        .bind(onNext: { owner, post in
            owner.makeUpUserView(post: post)
            owner.userNicknameLabel.text = post.user.nickname
            owner.dateLabel.text = post.timeStamp.convertDateToString(format: "yy.MM.dd")
            owner.postCaptionLabel.text = post.caption
            owner.makeUpStarPoint(post: post)
            owner.setPageControl(post: post)
            owner.makeUpComments(commentCount: post.commentCount)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPercent }
        .withUnretained(self)
        .bind(onNext: { owner, value in
            owner.makeUpBudgetCheck(currentPercent: value)
        })
        .disposed(by: disposeBag)
        
        // 포스트에서 변경되는 값, 좋아요, 북마크, 숫자
        reactor.state.map { $0.isHeart }
        .withUnretained(self)
        .bind(onNext: { owner, isHeart in
            owner.heartButton.setState(isHeart)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.heartCount }
        .withUnretained(self)
        .bind { owner, heartCount in
            owner.makeUpLikes(heartCount: heartCount)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBookmark }
        .withUnretained(self)
        .bind(onNext: { owner, isBookmark in
            owner.bookmarkButton.setState(isBookmark)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.bookmarkCount }
        .withUnretained(self)
        .bind { owner, bookmarkCount in
            owner.makeUpBookmark(bookmarkCount: bookmarkCount)
        }
        .disposed(by: disposeBag)
        
        // MARK: - Action
        
        heartButton.rx.tap
            .map { PostCellReactor.Action.heartbuttonTapped(self.heartButton.isActivated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .map { PostCellReactor.Action.bookmarkButtonTapped(self.bookmarkButton.isActivated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        commentListButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.navigateCommentVC(rootNaviVC: nil, post: reactor.currentState.post)
            })
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.presentReportActionVC(reactor: reactor, post: reactor.currentState.post, currentUser: reactor.currentState.user)
            })
            .disposed(by: disposeBag)
        
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        
        Observable.just(reactor.currentState.post.images)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "imageCell",
                                                   cellType: PostImageCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(imageURL: item)
            }
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
            
    }
    
    private func makeUpUserView(post: Post) {
        userImage.setImageWithKf(url: post.user.image)
        userImage.makeCircleView()
        userType.text = post.user.userType.rawValue
        userNickname.text = post.user.nickname
        location.text = "📍 " + post.location
    }
    
    private func makeUpStarPoint(post: Post) {
        starSlider.starPoint = post.star
        starSlider.starColor = .systemYellow
        starSlider.isEnabled = false
    }
    
    private func setPageControl(post: Post) {
        imagePageControl.isEnabled = false
        imagePageControl.hidesForSinglePage = true
        imagePageControl.numberOfPages = post.images.count
    }
    
    private func makeUpLikes(heartCount: Int) {
        userCountLabel.text = "좋아요 \(heartCount)개"
    }
    
    private func makeUpBookmark(bookmarkCount: Int) {
        bookmarkCountLabel.text = "북마크 \(bookmarkCount)개"
    }
    
    private func makeUpComments(commentCount: Int) {
        if commentCount == 0 {
            commentListButton.setTitle("아직 댓글이 없어요", for: .normal)
        } else {
            commentListButton.setTitle("댓글 \(commentCount)개 모두 보기", for: .normal)
        }
    }
    
    // 이 함수 구현하기
    private func makeUpBudgetCheck(currentPercent: Double) {
        if  currentPercent > 66 {
            let image = UIImage(systemName: "xmark.circle.fill")
            budgetCheckImage.image = image
            budgetCheckImage.tintColor = .systemRed
            budgetCheckLabel.text = "예산에 위험한 식사에요"
        } else if currentPercent > 33 {
            let image = UIImage(systemName: "minus.circle.fill")
            budgetCheckImage.image = image
            budgetCheckImage.tintColor = .systemYellow
            budgetCheckLabel.text = "흠.. 조금 고민이 되는 금액이에요"
        } else {
            let image = UIImage(systemName: "checkmark.circle.fill")
            budgetCheckImage.image = image
            budgetCheckImage.tintColor = .systemGreen
            budgetCheckLabel.text = "예산 범위 안에서 즐길 수 있는 식사에요"
        }
    }
    
}

extension PostTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.imagePageControl.currentPage = page
    }
    
}
