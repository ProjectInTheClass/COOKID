//
//  AddShoppingReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

enum ShoppingEditMode {
    case new
    case edit(Shopping)
}

class AddShoppingReactor: Reactor {
    
    enum Action {
        case inputDate(Date)
        case inputTotalPrice(String?)
        case uploadButtonTapped
        case deleteButtonTapped
    }
    
    enum Mutate {
        case setDate(Date)
        case setTotalPrice(String)
        case setPriceValidation(Bool?)
        case sendErrorMessage(Bool?)
        case setUser(User)
    }
    
    struct State {
        var user: User = DummyData.shared.secondUser
        var date: Date = Date()
        var totalPrice: String = ""
        var isPriceValid: Bool?
        var isError: Bool?
    }
    
    let serviceProvider: ServiceProviderType
    let mode: ShoppingEditMode
    let initialState: State
    
    init(mode: ShoppingEditMode, serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        self.mode = mode
        switch mode {
        case .new:
            self.initialState = State()
        case .edit(let shopping):
            self.initialState = State(date: shopping.date, totalPrice: String(describing: shopping.totalPrice), isPriceValid: true)
        }
    }
    
    func transform(mutation: Observable<Mutate>) -> Observable<Mutate> {
        let user = serviceProvider.userService.currentUser.map { Mutate.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
    func mutate(action: Action) -> Observable<Mutate> {
        switch action {
        case .inputDate(let date):
            return .just(Mutate.setDate(date))
        case .inputTotalPrice(let totalPrice):
            return .merge(
                .just(Mutate.setPriceValidation(self.checkPriceValidation(price: totalPrice))),
                .just(Mutate.setTotalPrice(totalPrice ?? ""))
            )
        case .uploadButtonTapped:
            let date = self.currentState.date
            let price = Int(self.currentState.totalPrice) ?? 0
            switch mode {
            case .new:
                let newShopping = Shopping(id: UUID().uuidString,
                                           date: date,
                                           totalPrice: price)
                let user = self.currentState.user
                return self.serviceProvider.shoppingService.create(shopping: newShopping, currentUser: user).map { Mutate.sendErrorMessage(!$0) }
            case .edit(let shopping):
                let updateShopping = Shopping(id: shopping.id,
                                           date: date,
                                           totalPrice: price)
                return self.serviceProvider.shoppingService.update(updateShopping: updateShopping).map { Mutate.sendErrorMessage(!$0) }
            }
        case .deleteButtonTapped:
            switch mode {
            case .new:
                return Observable.empty()
            case .edit(let shopping):
                let user = self.currentState.user
                return self.serviceProvider.shoppingService.deleteShopping(deleteShopping: shopping, currentUser: user)
                    .map { Mutate.sendErrorMessage(!$0)}
            }
        }
    }
    
    func reduce(state: State, mutation: Mutate) -> State {
        var newState = state
        switch mutation {
        case .setDate(let date):
            newState.date = date
            return newState
        case .setTotalPrice(let totalPrice):
            newState.totalPrice = totalPrice
            return newState
        case .setPriceValidation(let isValid):
            newState.isPriceValid = isValid
            return newState
        case .sendErrorMessage(let isError):
            newState.isError = isError
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
    
    func checkPriceValidation(price: String?) -> Bool? {
        guard let price = price, price != "" else { return nil }
        guard price.rangeOfCharacter(from: charSet) == nil else { return false }
        return true
    }
}
