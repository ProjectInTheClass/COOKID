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
    
    @IBOutlet weak var heartButton: HeartButton!
    @IBOutlet weak var bookmarkButton: BookMarkButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentListButton: UIButton!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    
    var coordinator: PostCoordinator?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func updateUI(viewModel: PostCellViewModel) {
        
        viewModel.output.post.star = 3
        postUserView.updateUI(post: viewModel.output.post)
        userNicknameLabel.text = viewModel.output.post.user.nickname
        postCaptionLabel.text = viewModel.output.post.caption
        dateLabel.text = viewModel.output.post.timestamp.convertDateToString(format: "yy.MM.dd")
        makeUpBookmark(post: viewModel.output.post)
        makeUpStar(post: viewModel.output.post)
        makeUpLikes(post: viewModel.output.post)
        setPageControl(post: viewModel.output.post)
        heartButton.setState(viewModel.output.post.didLike)
        bookmarkButton.setState(viewModel.output.post.didCollect)
        
        viewModel.output.user
            .drive(onNext: { [weak self] user in
                guard let self = self else { return }
                self.makeUpBudgetCheck(post: viewModel.output.post, user: user)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.comments
            .drive(onNext: { [weak self] comments in
                guard let self = self else { return }
                self.makeUpComments(commentCount: comments.count)
            })
            .disposed(by: disposeBag)
        
        heartButton.rx.tap
            .bind(onNext: { [unowned self] in
                viewModel.output.post.didLike = heartButton.isActivated
                
                if self.heartButton.isActivated {
                    viewModel.output.post.likes += 1
                } else {
                    viewModel.output.post.likes -= 1
                }
                viewModel.postService.updatePost(post: viewModel.output.post)
                
                self.makeUpLikes(post: viewModel.output.post)
            })
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(onNext: { [unowned self] in
                if self.bookmarkButton.isActivated {
                    viewModel.output.post.collections += 1
                } else {
                    viewModel.output.post.collections -= 1
                }
                viewModel.output.post.didCollect = bookmarkButton.isActivated
                
                viewModel.postService.updatePost(post: viewModel.output.post)
                self.makeUpBookmark(post: viewModel.output.post)
            })
            .disposed(by: disposeBag)
        
        detailButton.rx.tap
            .bind(onNext: { [unowned self] in
                self.postCaptionLabel.numberOfLines = 0
                self.detailButton.isHidden = true
            })
            .disposed(by: disposeBag)
        
        commentListButton.rx.tap
            .bind(onNext: { [unowned self] in
                coordinator?.navigateCommentVC(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        
        Observable.just(viewModel.output.post.images)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "imageCell", cellType: PostImageCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(url: item)
            }
            .disposed(by: rx.disposeBag)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
    
    private func setPageControl(post: Post) {
        imagePageControl.isEnabled = false
        imagePageControl.hidesForSinglePage = true
        imagePageControl.numberOfPages = post.images.count
    }
    
    private func makeUpLikes(post: Post) {
        userCountLabel.text = "좋아요 \(post.likes)개"
    }
    
    private func makeUpComments(commentCount: Int) {
        if commentCount == 0 {
            commentListButton.setTitle("아직 댓글이 없어요", for: .normal)
        } else {
            commentListButton.setTitle("댓글 \(commentCount)개 모두 보기", for: .normal)
        }
    }
    
    private func makeUpBookmark(post: Post) {
        bookmarkCountLabel.text = "북마크 \(post.collections)개"
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.postCaptionLabel.numberOfLines = 0
        self.detailButton.isHidden = true
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.imagePageControl.currentPage = page
    }
    
}
