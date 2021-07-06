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
    
    struct Input {
        
    }
    
    struct Output {
        let dineInProgress: Driver<CGFloat>
    }
    
    var input: Input
    var output: Output
    
    init(){
     
        // input initializer
        
        
        // output initializer
        let dineInProgressData = Observable<CGFloat>.create { observer in
            
            // service function
            let meals = DummyData.shared.myMeals
            observer.onNext(DummyData.shared.dineInProgressCalc(meals: meals))
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: 0)
        
        self.input = Input()
        self.output = Output(dineInProgress: dineInProgressData)
    }
    
}
