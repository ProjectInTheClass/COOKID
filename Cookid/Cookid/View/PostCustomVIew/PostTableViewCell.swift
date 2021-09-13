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
    @IBOutlet weak var postCaptionView: PostCaptionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(post: Post) {
        postUserView.updateUI(post: post)
        postCaptionView.updateUI(post: post)
       
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        
        Observable.just(post.images)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "imageCell", cellType: PostImageCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(url: item)
            }
            .disposed(by: rx.disposeBag)

        imageCollectionView.rx.setDelegate(self)
    }
}

extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("size")
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
