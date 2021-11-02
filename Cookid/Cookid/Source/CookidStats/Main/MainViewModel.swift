//
//  MainViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources

class MainViewModel: BaseViewModel, ViewModelType, HasDisposeBag {
    
    struct Input {
        let selectedDate = BehaviorRelay<Date>(value: Date())
    }
    
    struct Output {
        let basicMeals = PublishRelay<[Meal]>()
        let basicShoppings = PublishRelay<[Shopping]>()
        let userInfo = PublishRelay<User>()
        let recentMeals = PublishRelay<[Meal]>()
        let adviceString = PublishRelay<String>()
        let monthlyDetailed = PublishRelay<ConsumptionDetailed>()
        let consumeProgressCalc = PublishRelay<Double>()
        let averagePrice = PublishRelay<String>()
        let dineInProgress = PublishRelay<CGFloat>()
        let mostExpensiveMeal = PublishRelay<Meal>()
        let mealDayList = PublishRelay<[MainCollectionViewSection]>()
        let mealtimes = PublishRelay<[[Meal]]>()
    }
    
    var input: Input = Input()
    var output: Output = Output()
    let dataSource: RxCollectionViewSectionedReloadDataSource<MainCollectionViewSection>
    
    override init(serviceProvider: ServiceProviderType) {
        self.dataSource = MainDataSource.dataSouce
        super.init(serviceProvider: serviceProvider)
        
        // fetch data
        _ = serviceProvider.userService.loadMyInfo()
        serviceProvider.mealService.fetchMeals()
        serviceProvider.shoppingService.fetchShoppings()
        
        // meal & user Storage
        let currentUser = serviceProvider.userService.currentUser
        let basicMeals = serviceProvider.mealService.mealList
        let basicShoppings = serviceProvider.shoppingService.shoppingList
        let spotMonthMeals = basicMeals
            .map { self.spotMonthMeals(meals: $0) }
        let spotMonthShoppings = basicShoppings
            .map { self.spotMonthShoppings(shoppings: $0) }
        
        // calendar output
        basicMeals
            .bind(to: output.basicMeals)
            .disposed(by: disposeBag)
        
        basicShoppings
            .bind(to: output.basicShoppings)
            .disposed(by: disposeBag)
        
        // user information output
        currentUser
            .bind(to: output.userInfo)
            .disposed(by: disposeBag)
        
        // recentMeals
        spotMonthMeals
            .map { self.recentMeals(meals: $0) }
            .bind(to: output.recentMeals)
            .disposed(by: disposeBag)
        
        // adviceString
        Observable.combineLatest(
            spotMonthMeals,
            currentUser,
            spotMonthShoppings,
            resultSelector: self.checkSpendPace)
            .bind(to: output.adviceString)
            .disposed(by: disposeBag)
        
        // monthlyDetailed
        Observable.combineLatest(
            currentUser,
            spotMonthMeals.map(self.fetchEatOutSpend),
            spotMonthShoppings.map(self.fetchShoppingTotalSpend),
            resultSelector: self.makeConsumptionDetail)
            .bind(to: output.monthlyDetailed)
            .disposed(by: disposeBag)
        
        // consumeProgressCalc
        Observable.combineLatest(
            spotMonthMeals,
            currentUser,
            spotMonthShoppings,
            resultSelector: self.getSpendPercentage)
            .bind(to: output.consumeProgressCalc)
            .disposed(by: disposeBag)
        
        // averagePrice
        Observable.combineLatest(
            spotMonthShoppings.map(self.fetchShoppingTotalSpend),
            spotMonthMeals.map(self.fetchEatOutSpend),
            resultSelector: self.averagePriceToString)
            .bind(to: output.averagePrice)
            .disposed(by: disposeBag)
        
        // dineInProgress
        spotMonthMeals
            .map(self.dineInProgressCalc)
            .bind(to: output.dineInProgress)
            .disposed(by: disposeBag)
        
        // mostExpensiveMeal
        spotMonthMeals
            .map(self.mostExpensiveMeal)
            .bind(to: output.mostExpensiveMeal)
            .disposed(by: disposeBag)
        
        // mealDayList
        Observable.combineLatest(
            input.selectedDate,
            basicMeals,
            basicShoppings,
            resultSelector: self.makeMainCollectionViewSection)
            .bind(to: output.mealDayList)
            .disposed(by: disposeBag)
        
        // mealtimes
        spotMonthMeals
            .map(self.mealTimesCalc)
            .bind(to: output.mealtimes)
            .disposed(by: disposeBag)
    }
    
    func averagePriceToString(_ shoppingPrice: Int, _ mealPrice: Int) -> String {
        let day = Calendar.current.ordinality(of: .day, in: .month, for: Date()) ?? 1
        let value = Double(shoppingPrice + mealPrice) / Double(day)
        return "현재까지 하루 평균 지출은 '\(String(format: "%.0f", value))원' 입니다."
    }
    
    func spotMonthShoppings(shoppings: [Shopping]) -> [Shopping] {
        let startDay = Date().startOfMonth
        let endDay = Date().endOfMonth
        let filteredByStart = shoppings.filter { $0.date > startDay }
        let filteredByEnd = filteredByStart.filter { $0.date < endDay }
        let sortedshoppings = filteredByEnd.sorted { $0.date > $1.date }
        return sortedshoppings
    }
    
    func fetchShoppingByDay(_ day: Date, shoppings: [Shopping]) -> [Shopping] {
        let dayShoppings = shoppings.filter { $0.date.dateToString() == day.dateToString() }
        return dayShoppings
    }
    
    func fetchShoppingTotalSpend(shoppings: [Shopping]) -> Int {
        let shoppingSpends = shoppings.map { $0.totalPrice }.reduce(0, +)
        return shoppingSpends
    }
    
    func todayShoppings(shoppings: [Shopping]) -> [Shopping] {
        return shoppings.filter { $0.date.dateToString() == Date().dateToString() }
    }
    
    func fetchMealByNavigate(_ day: Int, currentDate: Date) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: day, to: currentDate) else { return Date() }
        return date
    }
    
    func fetchMealByDay(_ day: Date, meals: [Meal]) -> [Meal] {
        let dayMeals = meals.filter { $0.date.dateToString() == day.dateToString() }
        return dayMeals
    }

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
    
    func spotMonthMeals(meals: [Meal]) -> [Meal] {
        let startDay = Date().startOfMonth
        let endDay = Date().endOfMonth
        let filteredByStart = meals.filter { $0.date > startDay }
        let filteredByEnd = filteredByStart.filter { $0.date < endDay }
        let sortedMeals = filteredByEnd.sorted { $0.date > $1.date }
        return sortedMeals
    }
    
    // MARK: - Calculate for View
    
    func getSpendPercentage(meals: [Meal], user: User, shoppings: [Shopping]) -> Double {
        let shoppingSpends = shoppings.map { Double($0.totalPrice) }.reduce(0, +)
        let mealSpend = meals.map { Double($0.price) }.reduce(0, +)
        let spend = (shoppingSpends + mealSpend) / Double(user.priceGoal) * 100
        
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
        let currentSpend = meals.map { Double($0.price) }.reduce(0) { $0 + $1 }
        let average = currentSpend / Double(dayOfMonth)
        return average
    }
    
    func fetchEatOutSpend(meals: [Meal]) -> Int {
        let eatOutSpends = meals.filter {$0.mealType == .dineOut}.map { $0.price }
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
    
    func mealTimesCalc(_ meals: [Meal]) -> [[Meal]] {
        let breakfastNum = meals.filter { $0.mealTime == .breakfast}
        let brunchNum = meals.filter { $0.mealTime == .brunch}
        let lunchNum = meals.filter { $0.mealTime == .lunch}
        let lundinnerNum = meals.filter { $0.mealTime == .lundinner}
        let dinnerNum = meals.filter { $0.mealTime == .dinner}
        let snackNum = meals.filter { $0.mealTime == .snack}
        
        return [breakfastNum, brunchNum, lunchNum, lundinnerNum, dinnerNum, snackNum]
    }
    
    func makeConsumptionDetail(_ user: User, shoppingPrice: Int, dineOutPrice: Int) -> ConsumptionDetailed {
        return ConsumptionDetailed(
            month: Date().convertDateToString(format: "MM월"),
            priceGoal: user.priceGoal,
            shoppingPrice: shoppingPrice,
            dineOutPrice: dineOutPrice,
            balance: user.priceGoal - shoppingPrice - dineOutPrice)
    }
    
    func makeMainCollectionViewSection(_ date: Date, _ meals: [Meal], _ shoppings: [Shopping]) -> [MainCollectionViewSection] {
        let mealItem = self.fetchMealByDay(date, meals: meals)
            .map { MainCollectionViewItem.meals(meal: $0) }
        let shoppingItem = self.fetchShoppingByDay(date, shoppings: shoppings)
            .map { MainCollectionViewItem.shoppings(shopping: $0) }
        return [.mealSection(items: mealItem),
                .shoppingSection(items: shoppingItem)]
    }
                                                               
    // swiftlint:disable cyclomatic_complexity
    func checkSpendPace(_ meals: [Meal], _ user: User, _ shoppings: [Shopping]) -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        guard let day = components.day else { return "" }
        
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
                return "첫 주 예산의 끝에 다가가고 있습니다! 👮🏻‍♂️"
            } else if percentage < 50 {
                return "한 달 예산을 한 주에 너무 많이... 👮🏻‍♂️"
            } else if percentage < 80 {
                return "첫 주에 절반을 태워..? 👮🏻‍♂️"
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
            } else if percentage < 100 {
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
            } else if percentage < 100 {
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
    // swiftlint:enable cyclomatic_complexity
}

