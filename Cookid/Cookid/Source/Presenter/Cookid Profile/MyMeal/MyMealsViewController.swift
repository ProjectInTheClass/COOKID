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
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MyMealsCollectionViewCell.self, forCellWithReuseIdentifier: MyMealsCollectionViewCell.identifire)
    }
    
    private let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "placeholder")
    }
    
    private let backgroundLabel = UILabel().then {
        $0.text = "식사 기록이 없습니다.\n드셨던 식사를 추가해 보세요."
        $0.textAlignment = .center
        $0.textColor = .systemGray4
        $0.numberOfLines = 2
    }
    
    private lazy var backgroundStackView = UIStackView(arrangedSubviews: [backgroundImage, backgroundLabel]).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height / 2
        backgroundImage.layer.masksToBounds = true
    }
    
    private func makeConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(backgroundStackView)
        backgroundStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.33)
        }
    }
    
    func bindViewModel() {
        viewModel.output.meals
            .do(onNext: { [weak self] meals in
                guard let self = self else { return }
                self.backgroundStackView.isHidden = meals.count != 0
            })
            .bind(to: collectionView.rx.items(
                cellIdentifier: MyMealsCollectionViewCell.identifire,
                cellType: MyMealsCollectionViewCell.self)) { _, item, cell in
                    cell.updateUI(image: item.image)
            }
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.modelSelected(Meal.self)
            .bind(onNext: { [unowned self] meal in
                print("tapped")
//                guard let mainCoordinator = coordinator?.parentCoordinator.childCoordinator.first as? MainCoordinator else { return }
//                mainCoordinator.navigateAddMealVC(mode: .edit(meal))
            })
            .disposed(by: rx.disposeBag)
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
