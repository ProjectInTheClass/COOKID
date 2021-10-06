//
//  MyPostsViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx

class MyPostsViewController: UIViewController, ViewModelBindable {
    
    var viewModel: MyPageViewModel!
    var coordinator: MyPageCoordinator?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        collectionView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.myPostCollectionViewCell)
        collectionView.backgroundColor = .systemBackground
    }
    
    func bindViewModel() {
        viewModel.output.myPosts
            .bind(to: collectionView.rx.items(cellIdentifier: CELLIDENTIFIER.myPostCollectionViewCell, cellType: MyPostCollectionViewCell.self)) { _, item, cell in
                    cell.updateUI(post: item)
            }
            .disposed(by: rx.disposeBag)
    }
    
    func makeConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let verticalItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)))
        
        verticalItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
      
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)),
            subitem: verticalItem,
            count: 2)
        
        let tripleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let tripHorizentalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)),
            subitem: tripleItem,
            count: 2)
        
        let tripVerticalItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        tripVerticalItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let tripVerticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)),
            subitem: tripVerticalItem,
            count: 2)
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)),
            subitems: [tripHorizentalGroup, tripVerticalStackGroup])
        
        // Group
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)),
            subitems: [verticalStackGroup, item])
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)),
            subitems: [tripleHorizontalGroup, horizontalGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        // Return
        return UICollectionViewCompositionalLayout(section: section)
    }
}
