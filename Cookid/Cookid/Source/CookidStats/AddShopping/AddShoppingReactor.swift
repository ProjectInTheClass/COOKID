//
//  AddShoppingReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import Foundation
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
    }
    
    struct State {
        var date: Date = Date()
        var totalPrice: Int = 0
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
            self.initialState = State(date: shopping.date, totalPrice: shopping.totalPrice, isPriceValid: true)
        }
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
            switch mode {
            case .new:
                let newShopping = Shopping(id: UUID().uuidString,
                                           date: self.currentState.date,
                                           totalPrice: self.currentState.totalPrice)
                return self.serviceProvider.shoppingService.create(shopping: newShopping).map { Mutate.sendErrorMessage(!$0) }
            case .edit(let shopping):
                let updateShopping = Shopping(id: shopping.id,
                                           date: self.currentState.date,
                                           totalPrice: self.currentState.totalPrice)
                return self.serviceProvider.shoppingService.update(updateShopping: updateShopping).map { Mutate.sendErrorMessage(!$0) }
            }
        case .deleteButtonTapped:
            switch mode {
            case .new:
                return Observable.empty()
            case .edit(let shopping):
                return self.serviceProvider.shoppingService.deleteShopping(deleteShopping: shopping).map { Mutate.sendErrorMessage(!$0)}
            }
        }
    }
    
    func reduce(state: State, mutation: Mutate) -> State {
        var newState = state
        switch mutation {
        case .setDate(let date):
            newState.date = date
        case .setTotalPrice(let totalPriceStr):
            let totalPrice = Int(totalPriceStr) ?? 0
            newState.totalPrice = totalPrice
        case .setPriceValidation(let isValid):
            newState.isPriceValid = isValid
        case .sendErrorMessage(let isError):
            newState.isError = isError
        }
        return newState
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
