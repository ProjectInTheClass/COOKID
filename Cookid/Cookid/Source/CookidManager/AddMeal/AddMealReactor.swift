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
import Kingfisher

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
        case imageURL(URL?)
        case query(String)
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
        case setURLToImage(UIImage)
        case setQuery(String)
        case setPhotos([Photo])
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
        var photos = [Photo]()
        var query: String = ""
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
        let user = serviceProvider.userService.currentUser.map { Mutation.setUser($0) }
        let photos = serviceProvider.photoService.fetchPhotos(query: self.currentState.query).map { Mutation.setPhotos($0) }
        return Observable.merge(mutation, user, photos)
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
                let user = self.currentState.user
                return serviceProvider.mealService.deleteMeal(meal: meal, currentUser: user)
                    .map { Mutate.setError(!$0) }
            default:
                return Observable.empty()
            }
            
        case .imageURL(let url):
            return self.urlToImage(url: url).map { Mutation.setURLToImage($0) }
        case .query(let query):
            return .just(.setQuery(query))
        }
    }
    
    func reduce(state: State, mutation: Mutate) -> State {
        var newState = state
        switch mutation {
        case .setImage(let image):
            newState.image = image
        case .setDate(let date):
            newState.date = date
        case .setName(let name):
            newState.name = name
        case .setPrice(let price):
            newState.price = price
        case .setMealTime(let mealTime):
            newState.mealTime = mealTime
        case .setMealType(let mealType):
            newState.mealType = mealType
        case .setError(let isError):
            newState.isError = isError
        case .setPriceValidation(let priceValid):
            newState.priceValid = priceValid
        case .setUser(let user):
            newState.user = user
        case .setURLToImage(let image):
            newState.image = image
        case .setQuery(let query):
            newState.query = query
        case .setPhotos(let photos):
            newState.photos = photos
        }
        return newState
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
    
    func urlToImage(url: URL?) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            guard let url = url else {
                observer.onError(NetWorkingError.failure)
                return Disposables.create()
            }
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let result):
                    observer.onNext(result.image)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}
