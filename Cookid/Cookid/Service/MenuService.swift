//
//  MenuService.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/26.
//

import UIKit

class MenuService {
    static let shared = MenuService()
    
    var menus = [
        Menu(name: "salad", image: UIImage(named: "salad")),
        Menu(name: "pizza", image: UIImage(named: "pizza")),
        Menu(name: "rice", image: UIImage(named: "rice")),
        Menu(name: "noodle", image: UIImage(named: "noodle")),
        Menu(name: "hamburger", image: UIImage(named: "hamburger")),
        Menu(name: "dessert", image: UIImage(named: "dessert")),
        Menu(name: "seafood", image: UIImage(named: "seafood")),
        Menu(name: "meat", image: UIImage(named: "meat")),
        Menu(name: "bread", image: UIImage(named: "bread")),
        Menu(name: "etc", image: UIImage(named: "etc")),
        Menu(name: "ricesoup", image: UIImage(named: "ricesoup")),
        Menu(name: "soup", image: UIImage(named: "soup")),
    ]
    
}
