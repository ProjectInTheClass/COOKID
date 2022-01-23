//
//  MyPageViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import FirebaseCrashlytics
import FirebaseAnalytics

class MyPageViewModel: ViewModelType, HasDisposeBag {
   
    struct Input {
        let userImageSelect = PublishRelay<UIImage>()
        let userNickname = PublishRelay<String>()
        let userDetermination = PublishRelay<String>()
        let userBudget = PublishRelay<String>()
        let updateButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let userInfo = BehaviorRelay<User>(value: DummyData.shared.singleUser)
        let meals = BehaviorRelay<[Meal]>(value: [])
        let dineInCount = BehaviorRelay<Int>(value: 0)
        let cookidsCount = BehaviorRelay<Int>(value: 0)
        let myPostCount = BehaviorRelay<Int>(value: 0)
        let myPosts = BehaviorRelay<[Post]>(value: [])
        let completionUpdate = BehaviorRelay<Bool>(value: false)
    }
    
    var input: Input
    var output: Output
    
    let userService: UserServiceType
    let mealService: MealServiceType
    let shoppingService: ShoppingServiceType
    let postService: PostServiceType
    
    init(userService: UserServiceType,
         mealService: MealServiceType,
         shoppingService: ShoppingServiceType,
         postService: PostServiceType) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
        self.postService = postService
        self.input = Input()
        self.output = Output()

        let currentUser = userService.currentUser
        let meals = mealService.mealStore
        let shoppings = shoppingService.shoppingStore
        let myPosts = postService.myTotalPosts
        
        meals
            .bind(to: output.meals)
            .disposed(by: disposeBag)
        
        meals
            .map { $0.filter { $0.mealType == .dineIn }.count }
            .bind(to: output.dineInCount)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(meals, shoppings) { $0.count + $1.count }
            .bind(to: output.cookidsCount)
            .disposed(by: disposeBag)
        
        myPosts
            .map { $0.count }
            .bind(to: output.myPostCount)
            .disposed(by: disposeBag)
        
        myPosts
            .bind(to: output.myPosts)
            .disposed(by: disposeBag)
        
        currentUser
            .bind(to: output.userInfo)
            .disposed(by: disposeBag)
        
        input.userImageSelect
            .withLatestFrom(currentUser,
                            resultSelector: { ($0, $1) })
            .bind(onNext: { (image, user) in
                userService.updateUserImage(user: user, profileImage: image, completion: { _ in })
                Crashlytics.crashlytics().setUserID(user.id)
                Crashlytics.crashlytics().setCustomValue(image.size, forKey: "image_size")
                Analytics.logEvent("check_imagesize", parameters: [
                    "imagesize": image.size
                ])
            })
            .disposed(by: disposeBag)
        
        input.updateButtonTapped
            .withLatestFrom(
                Observable.combineLatest(
                    currentUser,
                    input.userNickname,
                    input.userDetermination,
                    input.userBudget,
                    resultSelector: { user, name, deter, budget -> [String:Any?] in
                        return [
                        "currentUser": user,
                        "nickName": name,
                        "determination": deter,
                        "budget": budget
                    ]}))
            .bind(onNext: { userInfo in
                guard let currentUser = userInfo["currentUser"] as? User else { return }
                guard let nickName = userInfo["nickName"] as? String,
                      nickName != "" else { return }
                let determination = userInfo["determination"] as? String ?? currentUser.determination
                let budget = userInfo["budget"] as? String ?? "\(currentUser.priceGoal)"
                let newUser = User(id: currentUser.id, image: currentUser.image, nickname: nickName, determination: determination, priceGoal: Int(budget) ?? currentUser.priceGoal, userType: currentUser.userType, dineInCount: currentUser.dineInCount, cookidsCount: currentUser.cookidsCount)
                userService.updateUserInfo(user: newUser, completion: { success in
                    if success {
                        self.output.completionUpdate.accept(true)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    func fetchInitialData(user: User) {
        self.userService.loadMyInfo()
        _ = self.postService.fetchMyPosts(currentUser: user)
        _ = self.postService.fetchBookmarkedPosts(currentUser: user)
    }
    
}
