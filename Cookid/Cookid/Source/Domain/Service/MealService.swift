//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import UIKit
import RxSwift
import RxCocoa

protocol MealServiceType {
    var initialDineInMeal: Int { get }
    var mealList: Observable<[Meal]> { get }
    var spotMonthMeals: Observable<[Meal]> { get }
    func create(meal: Meal?, currentUser: User) -> Observable<Bool>
    func fetchMeals()
    func update(updateMeal: Meal) -> Observable<Bool>
    func deleteMeal(meal: Meal, currentUser: User) -> Observable<Bool>
}

class MealService: BaseService, MealServiceType {
    
    let fileManagerRepo: FileManagerRepoType
    let realmMealRepo: RealmMealRepoType
    let firestoreUserRepo:UserRepoType
    init(fileManagerRepo: FileManagerRepoType,
         realmMealRepo: RealmMealRepoType,
         firestoreUserRepo:UserRepoType) {
        self.fileManagerRepo = fileManagerRepo
        self.realmMealRepo = realmMealRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
  
    private var meals: [Meal] = []
    private lazy var mealStore = BehaviorSubject<[Meal]>(value: meals)
    
    var initialDineInMeal: Int {
        return meals.filter { $0.mealType == .dineIn }.count
    }
    
    var mealList: Observable<[Meal]> {
        return mealStore
    }
    
    var spotMonthMeals: Observable<[Meal]> {
        return mealStore.map(sortSpotMonthMeals)
    }
    
    // MARK: - Meal Storage
    
    func create(meal: Meal?, currentUser: User) -> Observable<Bool> {
        guard let meal = meal else {
            return Observable.just(false)
        }
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.fileManagerRepo.saveImage(image: meal.image ?? UIImage(named: "salad")!, id: meal.id) { _ in }
            self.realmMealRepo.createMeal(meal: meal) {  success in
                if success {
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: true)
                    self.meals.append(meal)
                    self.mealStore.onNext(self.meals)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchMeals() {
        guard let meals = self.realmMealRepo.fetchMeals() else { return }
        let mealModels = meals.map {  model -> Meal in
            let id = model.id
            let price = model.price
            let date = model.date
            let name = model.name
            let image = self.fileManagerRepo.loadImage(id: model.id)
            let mealType = MealType(rawValue: model.mealType) ?? .dineIn
            let mealTime = MealTime(rawValue: model.mealTime) ?? .dinner
            return Meal(id: id, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
        }
        self.meals = mealModels
        self.mealStore.onNext(self.meals)
    }
    
    func update(updateMeal: Meal) -> Observable<Bool> {
        print("update")
        return Observable.create { observer in
            self.fileManagerRepo.saveImage(image: updateMeal.image ?? UIImage(named: "salad")!, id: updateMeal.id) { _ in }
            self.realmMealRepo.updateMeal(meal: updateMeal) { [weak self] success in
                guard let self = self else { return }
                if success {
                    if let index = self.meals.firstIndex(where: { $0.id == updateMeal.id }) {
                        self.meals.remove(at: index)
                        self.meals.insert(updateMeal, at: index)
                    }
                    self.mealStore.onNext(self.meals)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteMeal(meal: Meal, currentUser: User) -> Observable<Bool> {
        return Observable.create { observer in
            self.fileManagerRepo.deleteImage(id: meal.id) { _ in }
            self.realmMealRepo.deleteMeal(meal: meal) { [weak self] success in
                guard let self = self else { return }
                if success {
                    if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
                        self.meals.remove(at: index)
                    }
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: false)
                    self.mealStore.onNext(self.meals)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    private func sortSpotMonthMeals(meals: [Meal]) -> [Meal] {
        let startDay = Date().startOfMonth
        let endDay = Date().endOfMonth
        let filteredByStart = meals.filter { $0.date > startDay }
        let filteredByEnd = filteredByStart.filter { $0.date < endDay }
        let sortedMeals = filteredByEnd.sorted { $0.date > $1.date }
        return sortedMeals
    }
}
