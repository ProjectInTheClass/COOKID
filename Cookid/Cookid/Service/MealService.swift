//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import UIKit
import RxSwift

class MealService {
    
    let mealRepository: MealRepository
    let userRepository: UserRepository
    let groceryRepository: GroceryRepository
    
    private var totalBudget: Int = 1
    private var currentDay = Date()
    
    private var meals: [Meal] = []
    private lazy var mealStore = BehaviorSubject<[Meal]>(value: meals)
    
    init(mealRepository: MealRepository, userRepository: UserRepository, groceryRepository: GroceryRepository) {
        self.mealRepository = mealRepository
        self.userRepository = userRepository
        self.groceryRepository = groceryRepository
    }
    
    // MARK: - Meal Storage
    
    @discardableResult
    func create(meal: Meal, completion: @escaping (Bool)->Void) -> Observable<Meal> {
        print("create")
        mealRepository.uploadMealToFirebase(meal: meal) { key in meal.id = key }
        
        meals.append(meal)
        mealStore.onNext(meals)
        completion(true)
        return Observable.just(meal)
    }
    
    @discardableResult
    func mealList() -> Observable<[Meal]> {
        return mealStore
    }
    
    @discardableResult
    func update(updateMeal: Meal, completion: @escaping (Bool)->Void) -> Observable<Meal> {
        print("update")
        mealRepository.updateMealToFirebase(meal: updateMeal)
        
        if let index = meals.firstIndex(where: { $0.id == updateMeal.id }) {
            meals.remove(at: index)
            print("update" + updateMeal.name)
            meals.insert(updateMeal, at: index)
        }
        mealStore.onNext(meals)
        completion(true)
        return Observable.just(updateMeal)
    }
    
    func delete(mealID: String) {
        mealRepository.deleteMealToFirebase(mealID: mealID)
        mealRepository.deleteImage(mealID: mealID)
        if let index = meals.firstIndex(where: { $0.id == mealID }) {
            meals.remove(at: index)
        }
        mealStore.onNext(meals)
    }
    
    func fetchMeals(user: User, completion: @escaping ([Meal])->Void) {
        self.mealRepository.fetchMeals(user: user) { [unowned self] mealArr in
            let mealModels = mealArr.map {  model -> Meal in
                let id = model.id
                let price = model.price
                let date = Date(timeIntervalSince1970: TimeInterval(model.date))
                let name = model.name
                let image = model.image
                let mealType = MealType(rawValue: model.mealType) ?? .dineIn
                let mealTime = MealTime(rawValue: model.mealTime) ?? .dinner
                return Meal(id: id, price: price, date: date, name: name, image: URL(string: image!) ?? nil, mealType: mealType, mealTime: mealTime)
            }
            completion(mealModels)
            self.meals = mealModels
            self.mealStore.onNext(mealModels)
        }
    }
    
    func fetchMealByNavigate(_ day: Int) -> (String, [Meal]) {
        
        guard let aDay = Calendar.current.date(byAdding: .day, value: day, to: currentDay) else { return ("", []) }
        currentDay = aDay
        let dateString = convertDateToString(format: "YYYY년 M월 d일", date: aDay)
        let meal = self.meals.filter {$0.date.dateToString() == aDay.dateToString() }
        
        return (dateString, meal)
    }
    
    func fetchMealByDay(_ day: Date) -> (String, [Meal]) {
        currentDay = day
        let dateString = convertDateToString(format: "YYYY년 M월 d일", date: day)
        let meal = self.meals.filter { $0.date.dateToString() == day.dateToString() }
        return (dateString, meal)
    }
    
    @discardableResult
    func fetchMealImageURL(mealID: String) -> Observable<URL> {
        return Observable.create { [unowned self] observer in
            self.mealRepository.fetchImageURL(mealID: mealID) { url in
                observer.onNext(url)
            }
            return Disposables.create()
        }
    }
    
    func deleteImage(mealID: String) {
        mealRepository.deleteImage(mealID: mealID)
    }
    
    // MARK: - Validation
    
    private let charSet: CharacterSet = {
        var cs = CharacterSet.init(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNum(text: String) -> Bool {
        if text.isEmpty {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }
    
    func validationText(text: String) -> Bool {
        return text.count > 1
    }
    
    // MARK: - meal Calculate
    
    func todayMeals(meals: [Meal]) -> [Meal] {
        return meals.filter { $0.date.dateToString() == Date().dateToString() }
    }
    
    func mostExpensiveMeal(meals: [Meal]) -> Meal {
        let newMeals = meals.sorted { $0.price > $1.price }
        guard let firstMeal = newMeals.first else { return DummyData.shared.mySingleMeal }
        return firstMeal
    }
    
    func recentMeals(meals: [Meal]) -> [Meal] {
        
        guard let aWeekAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date()) else { return [] }
        let recentMeals = meals.filter { $0.date > aWeekAgo }
        let sortedMeals = recentMeals.sorted { $0.date > $1.date }
        return sortedMeals
    }
    
    // MARK: - Calculate for View
    
    func getSpendPercentage(meals: [Meal], user: User, shoppings: [GroceryShopping]) -> Double {
        
        let shoppingSpends = shoppings.map { Double($0.totalPrice) }.reduce(0, +)
        let mealSpend = meals.map{ Double($0.price) }.reduce(0, +)
        let spend = (shoppingSpends + mealSpend) / Double(user.priceGoal)! * 100
        
        if spend.isNaN {
            return 0
        } else {
            return spend
        }
    }
    
    func fetchAverageSpendPerDay(meals: [Meal]) -> Double {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        guard let dayOfMonth = components.day else {return 1}
        let currentSpend = meals.map{ Double($0.price) }.reduce(0){ $0 + $1 }
        let average = currentSpend / Double(dayOfMonth)
        return average
    }
    
    func fetchEatOutSpend(meals: [Meal]) -> Int {
        
        let eatOutSpends = meals.filter {$0.mealType == .dineOut}.map{$0.price}
        let totalSpend = eatOutSpends.reduce(0, +)
        return totalSpend
    }
    
    
    func dineInProgressCalc(meals: [Meal]) -> CGFloat {
        
        let newDineInMeals = meals.filter { $0.mealType == .dineIn }
        let newDineOutMeals = meals.filter { $0.mealType == .dineOut }
        
        if meals.isEmpty {
            return 0.5
        } else if newDineInMeals.isEmpty {
            return 0
        } else if newDineOutMeals.isEmpty {
            return 1
        } else {
            return CGFloat(newDineInMeals.count) / CGFloat(meals.count)
        }
        
    }
    
    func mealTimesCalc(meals: [Meal]) -> [[Meal]] {
        
        let breakfastNum = meals.filter { $0.mealTime == .breakfast}
        let brunchNum = meals.filter { $0.mealTime == .brunch}
        let lunchNum = meals.filter { $0.mealTime == .lunch}
        let lundinnerNum = meals.filter { $0.mealTime == .lundinner}
        let dinnerNum = meals.filter { $0.mealTime == .dinner}
        let snackNum = meals.filter { $0.mealTime == .snack}
        
        return [breakfastNum, brunchNum, lunchNum, lundinnerNum, dinnerNum, snackNum]
    }
  
    
    func checkSpendPace(meals: [Meal], user: User, shoppings: [GroceryShopping]) -> String{
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        guard let day = components.day else {return ""}
        
        let percentage = self.getSpendPercentage(meals: meals, user: user, shoppings: shoppings)
        
        switch day {
        case 1...7:
            if percentage == 0 {
                return "이번 달도 화이팅! 👍"
            } else if percentage < 6 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 12 {
                return "아직 (다음주에 덜 먹으면) 괜찮아요 👏"
            } else if percentage < 25 {
                return "첫 주 예산의 끝이 다가오고 있습니다! 👮🏻‍♂️"
            } else if percentage < 50 {
                return "첫 주에 절반을 태워..? 👮🏻‍♂️"
            } else if percentage < 80 {
                return "한 달 예산을 한 주에 너무 많이... 👮🏻‍♂️"
            } else if percentage < 100 {
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 8...14:
            if percentage == 0 {
                return "한 주가 지났어요ㅠ 어서 시작해보세요!"
            } else if percentage < 25 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 50 {
                return "아직 (다음주에 덜 먹으면) 괜찮아요 👏"
            } else if percentage < 75 {
                return "다음주에 굶으시려나보다 🙋🏻‍♂️"
            } else if percentage < 100{
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 15...21:
            if percentage == 0 {
                return "이번 달 식비관리 시작하세요!"
            } else if percentage < 50 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 75 {
                return "조금만 조절하면 당신은 현명한 소비자 💵"
            } else if percentage < 90 {
                return "다음주에 굶으시려나보다 🙋🏻‍♂️"
            } else if percentage < 100 {
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 22...28:
            if percentage == 0 {
                return "달의 막바지어도 시도해 보세요!"
            } else if percentage < 75 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 90 {
                return "다음주에 굶으시려나보다 🙋🏻‍♂️"
            } else if percentage < 100{
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        default:
            if percentage < 100 {
                return "어..? 예쁘다 💐"
            } else {
                return "예산을 초과했습니다 🚨"
            }
        }
    }
    
}
