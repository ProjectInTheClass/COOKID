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
    var coordinator: HomeCoordinator?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MyMealsViewController.createLayout())

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
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)))
        
        verticalItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)),
            subitem: verticalItem,
            count: 2)
        
        let tripleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)))
        
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.3)),
            subitem: tripleItem,
            count: 3)
        
        // Group
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.7)),
            subitems: [item, verticalStackGroup])
        
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
                let mainCoordinator = coordinator?.parentCoordinator as? MainCoordinator
                let tabBarController = mainCoordinator?.navigateHomeCoordinator() as? UITabBarController
                let nvc = tabBarController?.viewControllers?[0] as? UINavigationController
                guard let vc = nvc?.topViewController as? MainViewController else { return }
                let vm = vc.viewModel!
                self.coordinator?.navigateAddMealVC(viewModel: vm, meal: meal)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
