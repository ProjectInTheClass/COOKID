//
//  AddMealReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/13.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

enum MealEditMode {
    case new
    case edit(Meal)
}

class AddMealReactor: Reactor {
    
    let mealService: MealService
    var meal: Meal?
    
    enum Action {
        case image(UIImage)
        case date(Date)
        case mealTime(MealTime)
        case name(String)
        case mealType(MealType)
        case price(String?)
        case completion
        case delete
    }
    
    enum Mutate {
        case setImage(UIImage)
        case setDate(Date)
        case setName(String)
        case setPrice(String)
        case setMealTime(MealTime)
        case setMealType(MealType)
        case setError(Bool)
        case setLoading(Bool)
        case setMenus([Menu])
        case setPriceValidation(Bool?)
    }
    
    struct State {
        var isLoading: Bool = false
        var isError: Bool?
        let isUpdate: Bool
        var priceValid: Bool?
        var image: UIImage?
        var date: Date = Date()
        var name: String = ""
        var price: String = ""
        var mealTime: MealTime = .breakfast
        var mealType: MealType = .dineOut
        var menus: [Menu]  = []
    }
    
    let initialState: State
    
    init(mealService: MealService, meal: Meal?) {
        self.mealService = mealService
        self.meal = meal
        let isUpdate = meal != nil ? true : false
        if isUpdate {
            guard let meal = meal else {
                self.initialState = State(isUpdate: isUpdate)
                return
            }
            self.initialState = State(isUpdate: isUpdate, image: meal.image, date: meal.date, name: meal.name, price: String(describing: meal.price), mealTime: meal.mealTime, mealType: meal.mealType)
        } else {
            self.initialState = State(isUpdate: isUpdate)
        }
    }
    
    func transform(mutation: Observable<Mutate>) -> Observable<Mutate> {
        let menus = Observable.just(Mutate.setMenus(MenuService.shared.menus))
        return Observable.merge(mutation, menus)
    }
    
    func mutate(action: Action) -> Observable<Mutate> {
        switch action {
        case .image(let image):
            return Observable.just(Mutate.setImage(image))
        case .date(let date):
            return Observable.just(Mutate.setDate(date))
        case .mealTime(let mealTime):
            return Observable.just(Mutate.setMealTime(mealTime))
        case .name(let name):
            return Observable.just(Mutate.setName(name))
        case .mealType(let mealType):
            return Observable.just(Mutate.setMealType(mealType))
        case .price(let price):
            let validation = mealService.validationNumForPrice(text: price)
            return Observable.merge(Observable.just(Mutate.setPrice(price ?? "")),
                                    Observable.just(Mutate.setPriceValidation(validation)))
        case .completion:
            let mealID = meal != nil ? meal?.id : UUID().uuidString
            let price = Int(self.currentState.price) ?? 0
            let date = self.currentState.date
            let name = self.currentState.name
            let mealType = self.currentState.mealType
            let mealTime = self.currentState.mealTime
            let image = self.currentState.image
            let newMeal = Meal(id: mealID!, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
            let completeMeal = meal != nil ? mealService.update(updateMeal: newMeal) : mealService.create(meal: newMeal)
            return Observable.concat([
                Observable.just(Mutate.setLoading(true)),
                completeMeal.map { Mutate.setError(!$0) },
                Observable.just(Mutate.setLoading(false))
            ])
        case .delete:
            guard let meal = meal else { return Observable.empty() }
            return mealService.deleteMeal(meal: meal).map { Mutate.setError(!$0) }
        }
    }
    
    func reduce(state: State, mutation: Mutate) -> State {
        var newState = state
        switch mutation {
        case .setImage(let image):
            newState.image = image
            return newState
        case .setDate(let date):
            newState.date = date
            return newState
        case .setName(let name):
            newState.name = name
            return newState
        case .setPrice(let price):
            newState.price = price
            return newState
        case .setMealTime(let mealTime):
            newState.mealTime = mealTime
            return newState
        case .setMealType(let mealType):
            newState.mealType = mealType
            return newState
        case .setError(let isError):
            newState.isError = isError
            return newState
        case .setLoading(let isLoding):
            newState.isLoading = isLoding
            return newState
        case .setMenus(let menus):
            newState.menus = menus
            return newState
        case .setPriceValidation(let priceValid):
            newState.priceValid = priceValid
            return newState
        }
    }
    
}
