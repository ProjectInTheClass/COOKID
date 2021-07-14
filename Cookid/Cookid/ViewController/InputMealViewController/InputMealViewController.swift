////
////  InputShoppingListViewController.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/10.
////
//
import UIKit
import SwiftUI
import Combine

class InputMealViewController: UIViewController {
    
    let viewModel = MainViewModel(mealService: MealService(), userService: UserService(), shoppingService: ShoppingService())

    private let delegate = InputMealViewDelegate()
    private var cancellable: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let inputMealView = UIHostingController(rootView: InputMealView(mealDelegate: delegate,
             dismissView: {self.dismiss(animated: true, completion: nil)},
             saveButtonTapped: {
            self.cancellable = self.delegate.$meal.sink(receiveValue: { meal in
                guard let newMeal = meal else { return }
                self.viewModel.performCreate(meal: newMeal)
                print(newMeal.name)
            })}))
        
        inputMealView.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(inputMealView)
        self.view.addSubview(inputMealView.view)
        
        NSLayoutConstraint.activate([
            inputMealView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            inputMealView.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
    }
}


class InputMealViewDelegate: ObservableObject {
    @Published var meal: Meal?
}
