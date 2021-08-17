//
//  AddMealViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class AddMealViewModel: ViewModelType, HasDisposeBag {
    
    let mealService: MealService
    
    struct Input {
        var mealID: String? {
            didSet {
                print(mealID)
            }
        }
        let mealURL: BehaviorSubject<URL?>
        let isDineIn: BehaviorSubject<Bool>
        let mealName: BehaviorSubject<String>
        let mealDate: BehaviorSubject<Date>
        let mealTime: BehaviorSubject<MealTime>
        let mealType: BehaviorSubject<MealType>
        let mealPrice: BehaviorSubject<String>
    }
    
    struct Output {
        let newMeal: Observable<Meal>
        let validation: Driver<Bool>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, mealID: String? = nil) {
        self.mealService = mealService
        
        print(mealID)
        
        // 왜 항상 비헤이비어일까?
        // publish는 구독 이후에 전달되는 next이벤트를 처리하는데, 그거 때문에 초기에 방출한 이벤트들이 들어오지 않습니다. Behavior는 최근에 방출한 이벤트를 가져오기 때문에 초기값 세팅을 할 수 있어서 사용했어요~ 예를 들면 새로운 밀을 추가하는데는 default가 필요없지만 기존 밀을 가져오는데는 문제가 있습니다. 여긴 같은 뷰를 재사용하고 있기 때문에 모두를 만족시킬 코드를 작성한 것이구요! 처음에는 새로운 밀을 추가하는데도 필요했습니다. 매번 mealID를 onNext해서 Input해왔거든요...
        
        // 모델은 왜 클래스여야할까?
        // 저희 뷰모델은 하나의 인스턴스를 생성해서 의존성 역전(ViewModelType) & 주입으로 모든 곳에서 공유하고 있습니다(이게 프로토콜 지향의 장점...). 그래서 struct나 class나 별반 다를게 없지만, 스탠포드 강의에서 이야기하기로는 뷰모델은 뷰들에게 공유되기 때문에 기본적으로 class로 만든다고 들었습니다. 사실 class로 만든다면 좀 더 상위의 객체를 만들어서 protocol로 의존성 역전을 만드는게 아니라 상속으로 할 수도 있겠죠! 둘 다를 사용할수도 있을거구요~ 저희가 input output구조를 사용할 때는 initializer에 좀 더 신경쓰기 위해서, 뷰모델 관련 기타 확장성 때문에 일단은 class인데, 지금 단계서는 둘 사이의 차이점이 크지 않은 것 같아요~
        
        let mealURL = BehaviorSubject<URL?>(value: nil)
        let isDineIn = BehaviorSubject<Bool>(value: false)
        let mealName = BehaviorSubject<String>(value: "")
        let mealDate = BehaviorSubject<Date>(value: Date())
        let mealTime = BehaviorSubject<MealTime>(value: .breakfast)
        let mealType = BehaviorSubject<MealType>(value: .dineIn)
        let mealPrice = BehaviorSubject<String>(value: "")
        
        let validation = Observable.combineLatest(mealName, mealPrice, mealType) { name, price, type -> Bool in
       
            if type == .dineOut {
                guard name != "",
                      mealService.validationNum(text: price) else { return false }
            } else {
                guard name != "" else { return false }
            }
            return true
        }
        .asDriver(onErrorJustReturn: false)
        
      
        let newMeal = Observable.combineLatest(isDineIn, mealName, mealDate, mealTime, mealType, mealPrice) { isDineIn, name, date, mealTime, mealType, price -> Meal in
            
            let validMealPrice = Int(price) ?? 0

            return Meal(id: mealID ?? "", price: validMealPrice, date: date, name: name, image: URL(string: "url"), mealType: mealType, mealTime: mealTime)
        }
        
        self.input = Input(mealID: mealID, mealURL: mealURL, isDineIn: isDineIn, mealName: mealName, mealDate: mealDate, mealTime: mealTime, mealType: mealType, mealPrice: mealPrice)
        
        self.output = Output(newMeal: newMeal, validation: validation)
    }
}
