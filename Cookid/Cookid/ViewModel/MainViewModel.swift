//
//  MainViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    let service: MealService
    
    struct Input {
        
    }
    
    struct Output {
        let mealDayList: Driver<[Meal]>
    }
    
    var input: Input
    var output: Output
    
    init(service: MealService) {
        self.service = service
        
        let mealDayLists = Observable<[Meal]>.create { observer in
            
            let date = DummyData.shared.dateToMeal(date: Date())
            observer.onNext(date)
            
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: [])
        
        self.input = Input()
        self.output = Output(mealDayList: mealDayLists)
    }
    
    
}
