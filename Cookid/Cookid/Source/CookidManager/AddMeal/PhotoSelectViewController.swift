//
//  PhotoSelectViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import ReactorKit

class PhotoSelectViewController: BaseViewController, View {
    
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색어를 입력하세요"
        $0.hidesNavigationBarDuringPresentation = false
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 1
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(PhotoollectionViewCell.self, forCellWithReuseIdentifier: PhotoollectionViewCell.identifier)
        $0.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "사진 검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.safeAreaInsets.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
   
    func bind(reactor: AddMealReactor) {
        
        reactor.state.map { $0.photos }
        .bind(to: collectionView.rx.items(cellIdentifier: PhotoollectionViewCell.identifier, cellType: PhotoollectionViewCell.self)) { index, item, cell in
            cell.updateUI(photo: item)
        }
        .disposed(by: disposeBag)
        
        Observable
            .zip(collectionView.rx.modelSelected(Photo.self),
                 collectionView.rx.itemSelected)
            .bind(onNext: { (photo: Photo, indexPath: IndexPath) in
                self.collectionView.deselectItem(at: indexPath, animated: false)
                reactor.action.onNext(.imageURL(photo.url))
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension PhotoSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}
