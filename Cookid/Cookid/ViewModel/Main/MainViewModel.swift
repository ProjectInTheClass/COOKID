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
        let selectedDate: BehaviorRelay<Date>
    }
    
    struct Output {
        let averagePrice: Driver<String>
        let basicMeal: Observable<[Meal]>
        let basicShopping : Observable<[GroceryShopping]>
        let adviceString: Driver<String>
        let userInfo: Observable<User>
        let mealDayList: Driver<[MainCollectionViewSection]>
        let consumeProgressCalc: Driver<Double>
        let monthlyDetailed: Driver<ConsumptionDetailed>
        let dineInProgress: Driver<CGFloat>
        let mostExpensiveMeal: Driver<Meal>
        let mealtimes: Driver<[[Meal]]>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, shoppingService: ShoppingService) {
        self.mealService = mealService
        self.userService = userService
        self.shoppingService = shoppingService
        
        // fetch data
        userService.loadUserInfo()
        mealService.fetchMeals()
        shoppingService.fetchShoppings()
        
        // meal & user Storage
        
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()
        let userInfo = userService.user()
        
        // dataSouce
        
        self.dataSource = MainDataSource.dataSouce
        
        // input
        let selectedDate = BehaviorRelay<Date>(value: Date())
        
        // output
        
        let mealDayList = Observable.combineLatest(selectedDate, meals, shoppings) { date, meals, shoppings -> [MainCollectionViewSection] in
            let mealItem = mealService.fetchMealByDay(date, meals: meals).map { MainCollectionViewItem.meals(meal: $0) }
            let shoppingItem = shoppingService.fetchShoppingByDay(date, shoppings: shoppings).map { MainCollectionViewItem.shoppings(shopping: $0) }
            return [.mealSection(items: mealItem), .shoppingSection(items: shoppingItem)]
        }
        .asDriver(onErrorJustReturn: [])
        
        let monthlyDetailed = Observable.combineLatest(userInfo.asObservable(), meals, shoppings) { user, meals, shoppings -> ConsumptionDetailed in
            let shop = shoppingService.fetchShoppingTotalSpend(shoppings: shoppings)
            let dineOutPrice = mealService.fetchEatOutSpend(meals: meals)
            return ConsumptionDetailed(month: Date().convertDateToString(format: "MM월"), priceGoal: user.priceGoal, shoppingPrice: shop, dineOutPrice: dineOutPrice, balance: user.priceGoal - shop - dineOutPrice)
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
        
        let dineInProgress = meals.map(mealService.dineInProgressCalc)
            .asDriver(onErrorJustReturn: 0)

        let mostExpensiveMeal = meals.map(mealService.mostExpensiveMeal)
            .asDriver(onErrorJustReturn: DummyData.shared.mySingleMeal)

        let mealtimes = meals.map(mealService.mealTimesCalc(meals:))
            .asDriver(onErrorJustReturn: [])
        
        self.input = Input(selectedDate: selectedDate)
        self.output = Output(averagePrice: averagePrice, basicMeal: meals, basicShopping: shoppings, adviceString: adviceString, userInfo: userInfo, mealDayList: mealDayList, consumeProgressCalc: consumeProgressCalc, monthlyDetailed: monthlyDetailed, dineInProgress: dineInProgress, mostExpensiveMeal: mostExpensiveMeal, mealtimes: mealtimes)
    }
    
    func fetchMealByNavigate(_ day: Int, currentDate: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: day, to: currentDate) else { return Date() }
        return date
    }
    
}

struct ConsumptionDetailed {
    let month: String
    let priceGoal: Int
    let shoppingPrice: Int
    let dineOutPrice: Int
    let balance: Int
}
