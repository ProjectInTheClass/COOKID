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
    case shoppings(shopping: GroceryShopping)
}

enum MainCollectionViewSection {
    case MealSection(items: [MainCollectionViewItem])
    case ShoppingSection(items: [MainCollectionViewItem])
}

extension MainCollectionViewSection: SectionModelType {
    typealias Item = MainCollectionViewItem

    var header: String {
        switch self {
        case .MealSection:
            return "내 식사!"
        case .ShoppingSection:
            return "내 쇼핑!"
        }
    }

    var items: [Item] {
        switch self {
        case .MealSection(items: let items):
            return items
        case .ShoppingSection(items: let items):
            return items
        }
    }

    init(original: Self, items: [Item]) {
        switch original {
        case .MealSection(items: _):
            self = .MealSection(items: items)
        case .ShoppingSection(items: _):
            self = .ShoppingSection(items: items)
        }
    }

}

struct MainDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource

    static let dataSouce: DataSource<MainCollectionViewSection> = {
        let ds = DataSource<MainCollectionViewSection> { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .meals(meal: let meal):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.mainMealCell, for: indexPath) as! MealDayCollectionViewCell
                cell.updateUI(meal: meal)
                return cell

            case .shoppings(shopping: let shopping):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.mainShoppingCell, for: indexPath) as! ShoppingCollectionViewCell
                    cell.updateUI(shopping: shopping)
                    return cell
            }
        }
        return ds
    }()

}
