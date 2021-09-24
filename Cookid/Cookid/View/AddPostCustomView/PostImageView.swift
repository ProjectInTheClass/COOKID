//
//  PostImageView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import UIKit
import RxSwift
import SnapKit
import Then
import ReactorKit

class PostImageView: UIView {
    
    var images = [UIImage]()
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(AddPostImageCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.postImageCell)
        $0.register(AddPostCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    let imagePageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = .darkGray
        $0.currentPageIndicatorTintColor = .cyan
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setPageControl()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setPageControl()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.addSubview(imagePageControl)
        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func setPageControl() {
        imagePageControl.numberOfPages = images.count + 1
    }
    
}

extension PostImageView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.postImageCell, for: indexPath) as? AddPostImageCollectionViewCell else { return UICollectionViewCell() }
        cell.updateUI(image: images[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.imagePageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? AddPostCollectionReusableView else { return UICollectionReusableView() }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
