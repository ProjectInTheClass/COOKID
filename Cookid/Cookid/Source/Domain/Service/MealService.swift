//
//  Service.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/06.
//

import UIKit
import RxSwift
import RxCocoa

protocol MealServiceType {
    var initialDineInMeal: Int { get }
    var mealList: Observable<[Meal]> { get }
    func create(meal: Meal?, currentUser: User) -> Observable<Bool>
    func fetchMeals() -> Observable<[Meal]>
    func update(updateMeal: Meal) -> Observable<Bool>
    func deleteMeal(meal: Meal, currentUser: User) -> Observable<Bool>
}

class MealService: MealServiceType {
    
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
    
    // MARK: - Meal Storage
    
    private var meals: [Meal] = []
    private lazy var mealStore = BehaviorSubject<[Meal]>(value: meals)
    
    var initialDineInMeal: Int {
        return meals.filter { $0.mealType == .dineIn }.count
    }
    
    var mealList: Observable<[Meal]> {
        return mealStore
    }
    
    // MARK: - Meal CRUD
    
    func create(meal: Meal?, currentUser: User) -> Observable<Bool> {
        guard let meal = meal else {
            return Observable.just(false)
        }
        return Observable<Bool>.create { observer in
            self.fileManagerRepo.saveImage(image: meal.image ?? UIImage(named: "salad")!, id: meal.id) { _ in }
            self.realmMealRepo.createMeal(meal: meal) { success in
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
    
    func fetchMeals() -> Observable<[Meal]> {
        return Observable.create { observer in
            guard let localMeals = self.realmMealRepo.fetchMeals() else { return Disposables.create() }
            let meals = localMeals.map { model -> Meal in
                let image = self.fileManagerRepo.loadImage(id: model.id)
                return model.toDomain(image: image)
            }
            observer.onNext(meals)
            self.meals = meals
            self.mealStore.onNext(self.meals)
            return Disposables.create()
        }
    }
    
    func update(updateMeal: Meal) -> Observable<Bool> {
        print("update")
        return Observable.create { observer in
            self.fileManagerRepo.saveImage(image: updateMeal.image ?? UIImage(named: "salad")!, id: updateMeal.id) { _ in }
            self.realmMealRepo.updateMeal(meal: updateMeal) { success in
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
            self.realmMealRepo.deleteMeal(meal: meal) { success in
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
}
