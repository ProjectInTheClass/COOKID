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
    
    struct Input {
    }
    
    struct Output {
        let adviceString: Driver<String>
        let userInfo: Driver<User>
        let mealDayList: BehaviorSubject<[Meal]>
        let consumeProgressCalc: Driver<Int>
        let monthlyDetailed: Driver<ConsumptionDetailed>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService) {
        self.mealService = mealService
        self.userService = userService
        
        let dateToMealsCollect = BehaviorSubject<[Meal]>(value: DummyData.shared.dateToMeal(date: Date()))
        
        
        let adviceStr = Observable.create { observer in
            observer.onNext(mealService.checkSpendPace())
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: "비어 있습니다.")
        
        let userInform = Observable<User>.create { observer in
            userService.loadUserInfo { user in
                observer.onNext(user)
            }
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: User(userID: "userID", nickname: "비회원", determination: "등록 후에 사용해 주세요!", priceGoal: "2000", userType: .preferDineIn))
        
        let progressValue = Observable<Int>.create { observer in
            let percent = mealService.getSpendPercentage()
            observer.onNext(percent)
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: 0)
        
        let detailed = Observable<ConsumptionDetailed>.create { observer in
            
            let goal = Int(userService.currentUser.priceGoal) ?? 0
            let shop = mealService.fetchShoppingSpend()
            let dineOutPrice = mealService.fetchEatOutSpend()
            
            let value = ConsumptionDetailed(month: Date().convertDateToString(format: "MM월"), priceGoal: goal, shoppingPrice: shop, dineOutPrice: dineOutPrice, balance: goal - shop - dineOutPrice)
            
            observer.onNext(value)
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: ConsumptionDetailed(month: "1월", priceGoal: 0, shoppingPrice: 0, dineOutPrice: 0, balance: 0))
        
        self.input = Input()
        self.output = Output(adviceString: adviceStr, userInfo: userInform, mealDayList: dateToMealsCollect, consumeProgressCalc: progressValue, monthlyDetailed: detailed)
    }
   
    
}

struct ConsumptionDetailed {
    let month: String
    let priceGoal: Int
    let shoppingPrice: Int
    let dineOutPrice: Int
    let balance: Int
}
