//
//  MainViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import RxSwift
import RxCocoa
import NSObject_Rx

class MainViewModel: ViewModelType, HasDisposeBag {
    
    let mealService: MealService
    let userService: UserService
    let shoppingService: ShoppingService
    
    struct Input {
        let yesterdayMeals: PublishSubject<[Meal]>
        let tommorowMeals: PublishSubject<[Meal]>
        let todayMeals: PublishSubject<[Meal]>
    }
    
    struct Output {
        let basicMeal: Observable<[Meal]>
        let adviceString: Driver<String>
        let userInfo: Driver<User>
        let mealDayList: Driver<[Meal]>
        let consumeProgressCalc: Driver<Double>
        let monthlyDetailed: Driver<ConsumptionDetailed>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, shoppingService: ShoppingService) {
        self.mealService = mealService
        self.userService = userService
        self.shoppingService = shoppingService
        
        mealService.fetchMeals { meals in }
        shoppingService.fetchGroceries { _ in }
        
        // meal & user Storage
        
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()
        let userInfo = userService.user()
            .asDriver(onErrorJustReturn: User(userID: "none", nickname: "비회원", determination: "사용자 등록을 먼저 해주세요.", priceGoal: "0", userType: .preferDineOut))
        
        // input
        let yesterdayMeals = PublishSubject<[Meal]>()
        let tommorowMeals = PublishSubject<[Meal]>()
        let todayMeals = PublishSubject<[Meal]>()
        
        
        // output
        let initialMeal = meals.map(mealService.todayMeals)
        
        let mealDayList = Observable.of(initialMeal, yesterdayMeals, tommorowMeals, todayMeals)
            .merge()
            .asDriver(onErrorJustReturn: [])
        
        let monthlyDetailed = Observable.combineLatest(userInfo.asObservable(), meals, shoppings) { user, meals, shoppings -> ConsumptionDetailed in
            let goal = Int(user.priceGoal) ?? 0
            let shop = shoppingService.fetchShoppingTotalSpend(shoppings: shoppings)
            let dineOutPrice = mealService.fetchEatOutSpend(meals: meals)
            return ConsumptionDetailed(month: Date().convertDateToString(format: "MM월"), priceGoal: goal, shoppingPrice: shop, dineOutPrice: dineOutPrice, balance: goal - shop - dineOutPrice)
        }
        .asDriver(onErrorJustReturn: ConsumptionDetailed(month: "1월", priceGoal: 0, shoppingPrice: 0, dineOutPrice: 0, balance: 0))
        
        let consumeProgressCalc = Observable
            .combineLatest(userInfo.asObservable(), meals, shoppings) { user, meals, shoppings -> Double in
                return mealService.getSpendPercentage(meals: meals, user: user, shoppings: shoppings)
            }
            .asDriver(onErrorJustReturn: 0)
        
        let adviceString = Observable.combineLatest(meals, userInfo.asObservable(), shoppings) { meals, user, shoppings -> String in
            mealService.checkSpendPace(meals: meals, user: user, shoppings: shoppings)
        }
        .asDriver(onErrorJustReturn: "에러!")
        
        
        self.input = Input(yesterdayMeals: yesterdayMeals, tommorowMeals: tommorowMeals, todayMeals: todayMeals)
        self.output = Output(basicMeal: meals, adviceString: adviceString, userInfo: userInfo, mealDayList: mealDayList, consumeProgressCalc: consumeProgressCalc, monthlyDetailed: monthlyDetailed)
    }
    
    func performCreate(meal: Meal) {
        mealService.create(meal: meal)
    }
    
}

struct ConsumptionDetailed {
    let month: String
    let priceGoal: Int
    let shoppingPrice: Int
    let dineOutPrice: Int
    let balance: Int
}
