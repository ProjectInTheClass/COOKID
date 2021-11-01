//
//  MyMealsViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/08.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MyMealsViewController: UIViewController, ViewModelBindable {
    
    var viewModel: MyPageViewModel!
    var coordinator: MyPageCoordinator?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        collectionView.register(MyMealsCollectionViewCell.self, forCellWithReuseIdentifier: MyMealsCollectionViewCell.identifire)
        collectionView.backgroundColor = .systemBackground
    }
    
    private func makeConstraints() {
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
        
        // Group
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)),
            subitems: [item, verticalStackGroup])
        
        let tripleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)),
            subitem: tripleItem,
            count: 3)

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
    
    func bindViewModel() {
        viewModel.output.meals
            .bind(to: collectionView.rx.items(cellIdentifier: MyMealsCollectionViewCell.identifire, cellType: MyMealsCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(image: item.image)
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(Meal.self)
            .bind(onNext: { [unowned self] meal in
                print("tapped")
                guard let mainCoordinator = coordinator?.parentCoordinator.childCoordinator.first as? MainCoordinator else { return }
                mainCoordinator.navigateAddMealVC(meal: meal)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
