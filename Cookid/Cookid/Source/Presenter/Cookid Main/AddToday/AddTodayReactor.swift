//
//  AddTodayReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/11.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class AddTodayReactor: Reactor {
    
    enum Action {
        case breakfastPrice(String?)
        case lunchPrice(String?)
        case dinnerPrice(String?)
        case completeButtonTapped
    }
    
    enum Mutate {
        case setbreakfastValidation(Bool?)
        case setlunchValidation(Bool?)
        case setdinnerValidation(Bool?)
        case setBreakfastPrice(String?)
        case setLunchMealPrice(String?)
        case setDinnerMealPrice(String?)
        case setUser(User)
        case setIsLoading(Bool)
        case isError(Bool)
    }
    
    struct State {
        var user: User = DummyData.shared.secondUser
        var isError: Bool?
        var isLoading: Bool = false
        var breakfastValidation: Bool?
        var lunchValidation: Bool?
        var dinnerValidation: Bool?
        var breakfastPrice: String?
        var lunchMealPrice: String?
        var dinnerMealPrice: String?
    }
    
    let initialState: State
    let userService: UserServiceType
    let mealService: MealServiceType
    
    init(userService: UserServiceType,
         mealService: MealServiceType) {
        self.userService = userService
        self.mealService = mealService
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutate>) -> Observable<Mutate> {
        let user = self.userService.currentUser.map { Mutate.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
    func mutate(action: Action) -> Observable<Mutate> {
        switch action {
        case .breakfastPrice(let price):
            let breakfastMutate = Observable.just(Mutation.setBreakfastPrice(price))
            let validMutate = Observable.just(Mutate.setbreakfastValidation(self.validationNumOptional(text: price)))
            return Observable.merge(validMutate, breakfastMutate)
        case .lunchPrice(let price):
            let lunchMutate = Observable.just(Mutation.setLunchMealPrice(price))
            let validMutate = Observable.just(Mutate.setlunchValidation(self.validationNumOptional(text: price)))
            return Observable.merge(validMutate, lunchMutate)
        case .dinnerPrice(let price):
            let dinnerMutate = Observable.just(Mutation.setDinnerMealPrice(price))
            let validMutate = Observable.just(Mutate.setdinnerValidation(self.validationNumOptional(text: price)))
            return Observable.merge(validMutate, dinnerMutate)
        case .completeButtonTapped:
            let breakfastMeal = makeTodayMeal(action: .breakfastPrice("아침식사"), price: self.currentState.breakfastPrice)
            let lunchMeal = makeTodayMeal(action: .lunchPrice("점심식사"), price: self.currentState.lunchMealPrice)
            let dinnerMeal = makeTodayMeal(action: .dinnerPrice("저녁식사"), price: self.currentState.dinnerMealPrice)
            let user = self.currentState.user
            let createMeals = Observable<Bool>.combineLatest(
                self.mealService.create(meal: breakfastMeal, currentUser: user),
                self.mealService.create(meal: lunchMeal, currentUser: user),
                self.mealService.create(meal: dinnerMeal, currentUser: user)
            ) { b1, b2, b3 in return b1 || b2 || b3 }

            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                createMeals.map { Mutation.isError(!$0) },
                Observable.just(Mutation.setIsLoading(false))
            ])
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutate) -> State {
        var newState = state
        switch mutation {
        case .setbreakfastValidation(let bool):
            newState.breakfastValidation = bool
            return newState
        case .setlunchValidation(let bool):
            newState.lunchValidation = bool
            return newState
        case .setdinnerValidation(let bool):
            newState.dinnerValidation = bool
            return newState
        case .setBreakfastPrice(let string):
            newState.breakfastPrice = string
            return newState
        case .setLunchMealPrice(let string):
            newState.lunchMealPrice = string
            return newState
        case .setDinnerMealPrice(let string):
            newState.dinnerMealPrice = string
            return newState
        case .setIsLoading(let bool):
            newState.isLoading = bool
            return newState
        case .isError(let bool):
            newState.isError = bool
            return newState
        case .setUser(let user):
            newState.user = user
            return newState
        }
    }
    
    func makeTodayMeal(action: Action, price: String?) -> Meal? {
        guard let priceStr = price,
              priceStr != "" else { return nil }
        guard let value = Int(priceStr) else { return nil }
        var mealtime: MealTime?
        var mealName: String?
        
        switch action {
        case .breakfastPrice(_):
            mealtime = .breakfast
            mealName = "아침식사"
        case .lunchPrice(_):
            mealtime = .lunch
            mealName = "점심식사"
        case .dinnerPrice(_):
            mealtime = .dinner
            mealName = "저녁식사"
        default:
            break
        }
        
        return Meal(id: UUID().uuidString, price: value, date: Date(), name: mealName!, image: UIImage(named: "today"), mealType: .dineOut, mealTime: mealtime!)
    }
    
    private let charSet: CharacterSet = {
        var cs = CharacterSet(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNumOptional(text: String?) -> Bool? {
        guard let text = text, text != "" else { return nil }
        if text.isEmpty {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }
}
