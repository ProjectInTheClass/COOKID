//
//  MainViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources

class MainViewModel: ViewModelType, HasDisposeBag {
    
    let mealService: MealService
    let userService: UserService
    let shoppingService: ShoppingService
    let dataSource: RxCollectionViewSectionedReloadDataSource<MainCollectionViewSection>
    
    struct Input {
        let selectedDate: BehaviorSubject<Date>
        let yesterdayMeals: PublishSubject<([Meal], [GroceryShopping])>
        let tommorowMeals: PublishSubject<([Meal], [GroceryShopping])>
        let todayMeals: PublishSubject<([Meal], [GroceryShopping])>
    }
    
    struct Output {
        let averagePrice: Driver<String>
        let basicMeal: Observable<[Meal]>
        let basicShopping : Observable<[GroceryShopping]>
        let adviceString: Driver<String>
        let userInfo: Driver<User>
        let mealDayList: Driver<[MainCollectionViewSection]>
        let consumeProgressCalc: Driver<Double>
        let monthlyDetailed: Driver<ConsumptionDetailed>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, shoppingService: ShoppingService) {
        self.mealService = mealService
        self.userService = userService
        self.shoppingService = shoppingService
 
        // user
        userService.loadUserInfo { user in
            mealService.fetchMeals(user: user) { _ in }
            shoppingService.fetchShoppings(user: user) { _ in }
        }
        
        // meal & user Storage
        
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()
        let userInfo = userService.user()
            .asDriver(onErrorJustReturn: User(userID: "none", nickname: "비회원", determination: "사용자 등록을 먼저 해주세요.", priceGoal: "0", userType: .preferDineOut))
        
        // dataSouce
        
        self.dataSource = MainDataSource.dataSouce
        
        // input
        let selectedDate = BehaviorSubject<Date>(value: Date())
        
        let yesterdayMeals = PublishSubject<([Meal], [GroceryShopping])>()
        let tommorowMeals = PublishSubject<([Meal], [GroceryShopping])>()
        let todayMeals = PublishSubject<([Meal], [GroceryShopping])>()
        
        let initialMeal = meals.map(mealService.todayMeals)
        let initialShopping = shoppings.map(shoppingService.todayShoppings)
        
        // output
       
        let initialItems = Observable.combineLatest(initialMeal, initialShopping) { meals, shoppings -> ([Meal], [GroceryShopping])in
            return (meals, shoppings)
        }
        
        let mealDayList = Observable.of(initialItems, yesterdayMeals, tommorowMeals, todayMeals)
            .merge()
            .map { (meals, shoppings) -> [MainCollectionViewSection] in
                let mealItem = meals.map { MainCollectionViewItem.meals(meal: $0) }
                let shoppingItem = shoppings.map { MainCollectionViewItem.shoppings(shopping: $0) }
                return [.MealSection(items: mealItem), .ShoppingSection(items: shoppingItem)]
            }
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
        
        let averagePrice = Observable.combineLatest(shoppings.map(shoppingService.fetchShoppingTotalSpend), meals.map(mealService.fetchEatOutSpend)) { shoppingPrice, mealPrice -> Double in
            let day = Calendar.current.ordinality(of: .day, in: .month, for: Date()) ?? 1
            return Double(shoppingPrice + mealPrice) / Double(day)
        }
        .map({ price -> String in
            return "현재까지 하루 평균 지출은 '\(String(format: "%.0f", price))원' 입니다."
        })
        .asDriver(onErrorJustReturn: "지출이 없습니다.")
        
        
        self.input = Input(selectedDate: selectedDate, yesterdayMeals: yesterdayMeals, tommorowMeals: tommorowMeals, todayMeals: todayMeals)
        self.output = Output(averagePrice: averagePrice, basicMeal: meals, basicShopping: shoppings, adviceString: adviceString, userInfo: userInfo, mealDayList: mealDayList, consumeProgressCalc: consumeProgressCalc, monthlyDetailed: monthlyDetailed)
    }
    
    func logoutUser() {
        userService.userRepository.authRepo.userLogout { success in
            if success {
                print("success")
            } else {
                print("fail")
            }
        }
    }
    
}

struct ConsumptionDetailed {
    let month: String
    let priceGoal: Int
    let shoppingPrice: Int
    let dineOutPrice: Int
    let balance: Int
}
