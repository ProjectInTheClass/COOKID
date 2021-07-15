//
//  MyMealViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/06.
//

import RxSwift
import RxCocoa

class MyMealViewModel: ViewModelType {

    let mealService: MealService

    struct Input {
    }

    struct Output {
        let basicMeals: Observable<[Meal]>
        let dineInProgress: Driver<CGFloat>
        let mostExpensiveMeal: Driver<Meal>
        let recentMeals: Driver<[Meal]>
        let mealtimes: Driver<[[Meal]]>
    }

    var input: Input
    var output: Output

    init(mealService: MealService){

        self.mealService = mealService
       
        mealService.fetchMeals { meals in }
        
        // input initializer
        let meals = mealService.mealList()
       
        // output initializer
        
        let dineInProgress = meals.map(mealService.dineInProgressCalc(_:))
            .asDriver(onErrorJustReturn: 0)

        let mostExpensiveMeal = meals.map(mealService.mostExpensiveMeal)
            .asDriver(onErrorJustReturn: DummyData.shared.mySingleMeal)

        let recentMeals = meals.map(mealService.recentMeals)
            .asDriver(onErrorJustReturn: [])

        let mealtimes = meals.map(mealService.mealTimesCalc(meals:))
            .asDriver(onErrorJustReturn: [])

        self.input = Input()
        self.output = Output(basicMeals: meals, dineInProgress: dineInProgress, mostExpensiveMeal: mostExpensiveMeal, recentMeals: recentMeals, mealtimes: mealtimes)
    }

}
