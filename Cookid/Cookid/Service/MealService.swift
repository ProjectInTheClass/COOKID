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
    var mealList: Observable<[Meal]> { get }
    var initialDineInMeal: Int { get }
    func create(meal: Meal?) -> Observable<Bool>
    func fetchMeals()
    func update(updateMeal: Meal) -> Observable<Bool>
    func deleteMeal(meal: Meal) -> Observable<Bool>
}

class MealService: BaseService, MealServiceType {
  
    private var totalBudget: Int = 1
    private var meals: [Meal] = []
    private lazy var mealStore = BehaviorSubject<[Meal]>(value: meals)
    
    var initialDineInMeal: Int {
        return meals.filter { $0.mealType == .dineIn }.count
    }
    
    var mealList: Observable<[Meal]> {
        return mealStore
    }
    
    // MARK: - Meal Storage
    
    func create(meal: Meal?) -> Observable<Bool> {
        guard let meal = meal else {
            return Observable.just(false)
        }
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.imageRepo.saveImage(image: meal.image ?? UIImage(named: "salad")!, id: meal.id) { _ in }
            self.realmMealRepo.createMeal(meal: meal) {  success in
                if success {
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
    
    func update(updateMeal: Meal) -> Observable<Bool> {
        print("update")
        return Observable.create { observer in
            ImageRepo.instance.saveImage(image: updateMeal.image ?? UIImage(named: "salad")!, id: updateMeal.id) { _ in }
            RealmMealRepo.instance.updateMeal(meal: updateMeal) { [weak self] success in
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
    
    func deleteMeal(meal: Meal) -> Observable<Bool> {
        return Observable.create { observer in
            ImageRepo.instance.deleteImage(id: meal.id) { _ in }
            RealmMealRepo.instance.deleteMeal(meal: meal) { [weak self] success in
                guard let self = self else { return }
                if success {
                    if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
                        self.meals.remove(at: index)
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
    
    func fetchMeals() {
        guard let meals = RealmMealRepo.instance.fetchMeals() else { return }
        let mealModels = meals.map {  model -> Meal in
            let id = model.id
            let price = model.price
            let date = model.date
            let name = model.name
            let image = ImageRepo.instance.loadImage(id: model.id)
            let mealType = MealType(rawValue: model.mealType) ?? .dineIn
            let mealTime = MealTime(rawValue: model.mealTime) ?? .dinner
            return Meal(id: id, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
        }
        self.meals = mealModels
        self.mealStore.onNext(mealModels)
    }
    
}
