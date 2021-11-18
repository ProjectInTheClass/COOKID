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
    
    enum Action {
        case image(UIImage)
        case date(Date)
        case mealTime(MealTime)
        case name(String)
        case mealType(MealType)
        case price(String?)
        case upload
        case delete
    }
    
    enum Mutate {
        case setUser(User)
        case setImage(UIImage)
        case setDate(Date)
        case setName(String)
        case setPrice(String)
        case setMealTime(MealTime)
        case setMealType(MealType)
        case setError(Bool)
        case setPriceValidation(Bool?)
    }
    
    struct State {
        var user: User = DummyData.shared.secondUser
        var image: UIImage?
        var date: Date = Date()
        var name: String = ""
        var price: String = ""
        var mealTime: MealTime = .breakfast
        var mealType: MealType = .dineOut
        var menus: [Menu]  = MenuService.shared.menus
        var isError: Bool?
        var priceValid: Bool?
    }
    
    let mode: MealEditMode
    let initialState: State
    let serviceProvider: ServiceProviderType
    
    init(mode: MealEditMode, serviceProvider: ServiceProviderType) {
        self.mode = mode
        self.serviceProvider = serviceProvider
        switch mode {
        case .new:
            self.initialState = State()
        case .edit(let meal):
            self.initialState = State(image: meal.image, date: meal.date, name: meal.name, price: String(describing: meal.price), mealTime: meal.mealTime, mealType: meal.mealType)
        }
    }
    
    func transform(mutation: Observable<Mutate>) -> Observable<Mutate> {
        let user = serviceProvider.userService.currentUser.map { Mutate.setUser($0) }
        return Observable.merge(mutation, user)
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
            let validation = self.validationNumForPrice(text: price)
            return Observable.merge(
                Observable.just(Mutate.setPrice(price ?? "")),
                Observable.just(Mutate.setPriceValidation(validation)))
        case .upload:
            let price = Int(self.currentState.price) ?? 0
            let date = self.currentState.date
            let name = self.currentState.name
            let mealType = self.currentState.mealType
            let mealTime = self.currentState.mealTime
            let image = self.currentState.image
            let user = self.currentState.user
            switch mode {
            case .new:
                let newMeal = Meal(id: UUID().uuidString, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
                return serviceProvider.mealService.create(meal: newMeal, currentUser: user)
                    .map { Mutate.setError(!$0) }
            case .edit(let meal):
                let newMeal = Meal(id: meal.id, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
                return serviceProvider.mealService.update(updateMeal: newMeal)
                    .map { Mutate.setError(!$0) }
            }
        case .delete:
            switch mode {
            case .edit(let meal):
                return serviceProvider.mealService.deleteMeal(meal: meal)
                    .map { Mutate.setError(!$0) }
            default:
                return Observable.empty()
            }
            
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
        case .setPriceValidation(let priceValid):
            newState.priceValid = priceValid
            return newState
        case .setUser(let user):
            newState.user = user
            return newState
        }
    }
    
    private let charSet: CharacterSet = {
        var cs = CharacterSet(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNumForPrice(text: String?) -> Bool? {
        guard let text = text, text != "" else { return nil }
        guard text.rangeOfCharacter(from: charSet) == nil else { return false }
        return true
    }
    
}
