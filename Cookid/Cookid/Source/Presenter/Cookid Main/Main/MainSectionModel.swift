//
//  MainSectionModel.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import RxDataSources

struct ConsumptionDetailed {
    let month: String
    let priceGoal: Int
    let shoppingPrice: Int
    let dineOutPrice: Int
    let balance: Int
}

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
