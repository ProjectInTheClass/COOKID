//
//  MyMealViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/06.
//

import Foundation
import RxSwift
import RxCocoa

class MyMealViewModel: ViewModelType {

    let service: MealService

    struct Input {

    }

    struct Output {

        func dineInProgressCalc(meals: [Meal]) -> CGFloat {
            let newMeals = meals.filter { $0.mealType == .dineIn }
            return CGFloat(newMeals.count) / CGFloat(meals.count)
        }

        let mostExpensiveMeal: Driver<Meal>
        let recentMeals: Driver<[Meal]>
        let mealtimes: Driver<[[Meal]]>
    }

    var input: Input
    var output: Output

    init(service: MealService){

        self.service = service
        // input initializer


        // output initializer

        let expensiveMeal = Observable<Meal>.create { observer in
            guard let newMeal = service.mostExpensiveMeal(meals: DummyData.shared.myMeals) else { return Disposables.create() }
            observer.onNext(newMeal)
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: Meal(price: 2000, date: Date(), name: "제육볶음", image: "square.and.arrow.down.fill", mealType: .dineIn, mealTime: .lunch))

        let aWeekAgoMeals = Observable<[Meal]>.create { observer in
            let newMeal = service.recentMeals(meals: DummyData.shared.myMeals)
            observer.onNext(newMeal)
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: [])

        let mealTimeNum = Observable<[[Meal]]>.create { observer in

            let mealsNums = service.mealTimesCalc(meals: DummyData.shared.myMeals)
            observer.onNext(mealsNums)

            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: [])

        self.input = Input()
        self.output = Output(mostExpensiveMeal: expensiveMeal, recentMeals: aWeekAgoMeals, mealtimes: mealTimeNum)
    }

}
