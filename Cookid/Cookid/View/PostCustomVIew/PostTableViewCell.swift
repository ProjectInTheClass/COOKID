//
//  PostTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postUserView: PostUserView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBOutlet weak var budgetCheckImage: UIImageView!
    @IBOutlet weak var budgetCheckLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentListButton: UIButton!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(post: Post, user: User, commentCount: Int) {
        postUserView.updateUI(post: post)
        updateCaptionView(post: post, user: user, commentCount: commentCount)
        setPageControl(post: post)
        
        
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        
        Observable.just(post.images)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "imageCell", cellType: PostImageCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(url: item)
                print("image collectionView Cell")
            }
            .disposed(by: rx.disposeBag)
        
        imageCollectionView.rx.setDelegate(self)
    }
    
    private func setPageControl(post: Post) {
        imagePageControl.hidesForSinglePage = true
        imagePageControl.numberOfPages = post.images.count
    }
    
    private func updateCaptionView(post: Post, user: User, commentCount: Int) {
        post.star = 2
        makeUpLikes(post: post)
        makeUpComments(commentCount: commentCount)
        makeUpBookmark(post: post)
        makeUpStar(post: post)
        makeUpBudgetCheck(post: post, user: user)
        userNicknameLabel.text = post.user.nickname
        postCaptionLabel.text = post.caption
        dateLabel.text = post.timestamp.dateToString()
    }
    
    private func makeUpLikes(post: Post) {
        if post.likes == 0 && post.didLike == false {
            userCountLabel.text = "이 추천이 마음에 드시면 하트를 눌러주세요 "
        } else if post.likes == 1 && post.didLike == true {
            userCountLabel.text = "\(post.user.nickname)님이 이 추천을 좋아해요"
        } else {
            userCountLabel.text = "\(post.user.nickname)님 외 \(post.likes)명이 이 추천을 좋아해요"
        }
    }
    
    private func makeUpComments(commentCount: Int) {
        if commentCount == 0 {
            commentListButton.setTitle("아직 댓글이 없습니다", for: .normal)
        } else {
            commentListButton.setTitle("\(commentCount)개의 댓글이 있어요", for: .normal)
        }
    }
    
    private func makeUpBookmark(post: Post) {
        if post.collections == 0 {
            bookmarkCountLabel.text = "나만의 공간에 이 추천을 저장하세요"
        } else {
            bookmarkCountLabel.text = "\(post.collections)명이 저장한 추천이에요"
        }
    }
    
    private func makeUpStar(post: Post) {
        switch post.star {
        case 1:
            firstStar.isHidden = true
            secondStar.isHidden = true
        case 2:
            firstStar.isHidden = false
            secondStar.isHidden = true
        default:
            print(post.star)
        }
    }
    
    private func makeUpBudgetCheck(post: Post, user: User) {
        let image = UIImage(systemName: "checkmark.fill")
        if post.mealBudget / user.priceGoal * 100 > 50 {
            image?.withTintColor(.systemYellow)
            budgetCheckImage.image = image
            budgetCheckLabel.text = "흠.. 조금 고민이 되는 금액이에요"
        } else {
            image?.withTintColor(.systemGreen)
            budgetCheckImage.image = image
            budgetCheckLabel.text = "예산 범위 안에서 즐길 수 있는 식사에요"
        }
    }
}

extension PostTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("size")
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.imagePageControl.currentPage = page
      }
    
    
}