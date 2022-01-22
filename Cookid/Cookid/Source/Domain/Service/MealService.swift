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
    var mealStore: BehaviorSubject<[Meal]> { get }
    var initialDineInMeal: Int { get }
    func create(meal: Meal?, currentUser: User) -> Observable<Bool>
    func fetchMeals()
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
    lazy var mealStore = BehaviorSubject<[Meal]>(value: meals)
    
    // MARK: - Meal CRUD
    
    var initialDineInMeal: Int {
        return meals.filter { $0.mealType == .dineIn }.count
    }
    
    func fetchMeals() {
        guard let localMeals = self.realmMealRepo.fetchMeals() else { return }
        let meals = localMeals.map { model -> Meal in
            let image = self.fileManagerRepo.loadImage(id: model.id)
            return model.toDomain(image: image)
        }
        self.meals = meals
        self.mealStore.onNext(self.meals)
    }
    
    func create(meal: Meal?, currentUser: User) -> Observable<Bool> {
        guard let meal = meal else {
            return Observable.just(false)
        }
        return Observable<Bool>.create { observer in
            self.fileManagerRepo.saveImage(image: meal.image ?? UIImage(named: "salad")!, id: meal.id) { success in
                if success {
                    self.realmMealRepo.createMeal(meal: meal) { success in
                        if success {
                            self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: true)
                            self.meals.append(meal)
                            self.mealStore.onNext(self.meals)
                            observer.onNext(true)
                            observer.onCompleted()
                        } else {
                            observer.onNext(false)
                            observer.onCompleted()
                        }
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            
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
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
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
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
