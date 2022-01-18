//
//  MainSectionModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/23.
//

import Foundation
import RxDataSources

enum MainCollectionViewItem {
    case meals(meal: Meal)
    case shoppings(shopping: Shopping)
}

enum MainCollectionViewSection {
    case mealSection(items: [MainCollectionViewItem])
    case shoppingSection(items: [MainCollectionViewItem])
}

extension MainCollectionViewSection: SectionModelType {
    typealias Item = MainCollectionViewItem
   
    var header: String {
        switch self {
        case .mealSection:
            return "내 식사!"
        case .shoppingSection:
            return "내 쇼핑!"
        }
    }

    var items: [Item] {
        switch self {
        case .mealSection(items: let items):
            return items
        case .shoppingSection(items: let items):
            return items
        }
    }

    init(original: Self, items: [Item]) {
        switch original {
        case .mealSection(items: _):
            self = .mealSection(items: items)
        case .shoppingSection(items: _):
            self = .shoppingSection(items: items)
        }
    }

}

struct MainDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource

    static let dataSouce: DataSource<MainCollectionViewSection> = {
        let ds = DataSource<MainCollectionViewSection> { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .meals(meal: let meal):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.mainMealCell, for: indexPath) as? MealDayCollectionViewCell else { return UICollectionViewCell() }
                cell.updateUI(meal: meal)
                return cell

            case .shoppings(shopping: let shopping):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.mainShoppingCell, for: indexPath) as? ShoppingCollectionViewCell else { return UICollectionViewCell() }
                    cell.updateUI(shopping: shopping)
                    return cell
            }
        }
        return ds
    }()

}
