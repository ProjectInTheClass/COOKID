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
    @IBOutlet weak var reportButton: UIImageView!
    
    var coordinator: PostCoordinator?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(reactor: PostCellReactor) {
        
        if postCaptionLabel.isTruncated {
            detailButton.isHidden = false
        } else {
            detailButton.isHidden = true
        }
        
        // MARK: - Reactor Binding
        
        reactor.state.map { $0.post }
        .withUnretained(self)
        .bind(onNext: { owner, post in
            owner.makeUpUserView(post: post)
            owner.userNicknameLabel.text = post.user.nickname
            owner.dateLabel.text = post.timeStamp.convertDateToString(format: "yy.MM.dd")
            owner.postCaptionLabel.text = post.caption
            owner.makeUpStarPoint(post: post)
            owner.setPageControl(post: post)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isHeart }
        .withUnretained(self)
        .bind(onNext: { owner, isHeart in
            owner.heartButton.setState(isHeart)
            owner.makeUpLikes(post: reactor.currentState.post)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBookmark }
        .withUnretained(self)
        .bind(onNext: { owner, isBookmark in
            owner.bookmarkButton.setState(isBookmark)
            owner.makeUpBookmark(post: reactor.currentState.post)
        })
        .disposed(by: disposeBag)
        
        Observable.combineLatest(reactor.state.map { $0.post },
                                 reactor.state.map { $0.user },
                                 resultSelector: { user, post in
            return (user, post)
        })
        .withUnretained(self)
        .bind(onNext: { owner, info in
            owner.makeUpBudgetCheck(post: info.0, user: info.1)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.comments }
        .withUnretained(self)
        .bind(onNext: { owner, comments in
            print(comments)
            owner.makeUpComments(commentCount: comments.count)
        })
        .disposed(by: disposeBag)
        
        // MARK: - Action
        
        heartButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.heartbuttonTapped(owner.heartButton.isActivated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.bookmarkButtonTapped(owner.bookmarkButton.isActivated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        commentListButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.navigateCommentVC()
            })
            .disposed(by: disposeBag)
        
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        
        Observable.just(reactor.currentState.post.images)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "imageCell", cellType: PostImageCollectionViewCell.self)) { _, item, cell in
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
        location.text = "📮 " + post.location
    }
    
    private func makeUpStarPoint(post: Post) {
        for index in 0...post.star {
            if let tagView = self.contentView.viewWithTag(index) as? UIImageView {
                tagView.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    private func setPageControl(post: Post) {
        imagePageControl.isEnabled = false
        imagePageControl.hidesForSinglePage = true
        imagePageControl.numberOfPages = post.images.count
    }
    
    private func makeUpLikes(post: Post) {
        userCountLabel.text = "좋아요 \(post.likes)개"
    }
    
    private func makeUpBookmark(post: Post) {
        bookmarkCountLabel.text = "북마크 \(post.collections)개"
    }
    
    private func makeUpComments(commentCount: Int) {
        if commentCount == 0 {
            commentListButton.setTitle("아직 댓글이 없어요", for: .normal)
        } else {
            commentListButton.setTitle("댓글 \(commentCount)개 모두 보기", for: .normal)
        }
    }
    
    private func makeUpBudgetCheck(post: Post, user: User) {
        if Double(post.mealBudget) / Double(user.priceGoal) * 100 > 66 {
            let image = UIImage(systemName: "xmark.circle.fill")
            budgetCheckImage.image = image
            budgetCheckImage.tintColor = .systemRed
            budgetCheckLabel.text = "예산에 위험한 식사에요"
        } else if Double(post.mealBudget) / Double(user.priceGoal) * 100 > 33 {
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
