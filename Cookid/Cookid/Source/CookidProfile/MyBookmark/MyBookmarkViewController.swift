//
//  MyBookmarkViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/04.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class MyBookmarkViewController: UIViewController, View {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MyBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.myBookmarkCollectionViewCell)
        $0.backgroundColor = .systemBackground
    }
    
    private var loadingIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
        $0.size(100)
    }
    
    var coordinator: MyPageCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func makeConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: MyBookmarkReactor) {
        
        reactor.state.map { $0.bookmarkPosts }
        .bind(to: collectionView.rx.items(cellIdentifier: CELLIDENTIFIER.myBookmarkCollectionViewCell, cellType: MyBookmarkCollectionViewCell.self)) { _, item, cell in
            cell.reactor = PostCellReactor(sender: self, post: item, serviceProvider: reactor.serviceProvider)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Post.self)
            .withUnretained(self)
            .bind { owner, post in
                guard let postCoordinator = owner.coordinator?.parentCoordinator.childCoordinator[1] as? PostCoordinator else { return }
                postCoordinator.navigateCommentVC(rootNaviVC: owner.coordinator?.navigationController, post: post)
            }
            .disposed(by: disposeBag)
        
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
        
        let tripHorizentalItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        tripHorizentalItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let tripHorizentalStackGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)),
            subitem: tripHorizentalItem,
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
            subitems: [tripVerticalStackGroup, tripHorizentalStackGroup])
        
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
            subitems: [horizontalGroup, tripleHorizontalGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        // Return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
