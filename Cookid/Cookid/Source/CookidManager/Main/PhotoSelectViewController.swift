//
//  PhotoSelectViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import UIKit
import SnapKit
import Then

class PhotoSelectViewController: BaseViewController {
    
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색어를 입력하세요"
        $0.hidesNavigationBarDuringPresentation = false
    }
    
    private let collectionView = UICollectionView().then {
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
    
}
