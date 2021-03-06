//
//  AddPostReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import YPImagePicker
import Kingfisher
import FirebaseAnalytics

enum PostEditViewMode {
    case new
    case edit(Post)
}

class AddPostReactor: Reactor {
    
    enum Action {
        case imageUpload([UIImage])
        case inputRegion(String)
        case inputCaption(String)
        case inputPrice(Int)
        case inputStar(Int)
        case uploadPostButtonTapped
    }
    
    enum Mutation {
        case setRegion(String)
        case setCaption(String)
        case setPrice(Int)
        case setStar(Int)
        case setImages([UIImage])
        case setUser(User)
        case setLoading(Bool)
        case sendErrorMessage(Bool?)
        case setValidation(Bool)
    }
    
    struct State {
        var images: [UIImage]
        var caption: String = "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)"
        var region: String
        var price: Int = 0
        var star: Int = 0
        var user: User = DummyData.shared.singleUser
        var isLoading: Bool = false
        var isError: Bool?
        var isValid: Bool = false
    }

    let mode: PostEditViewMode
    var initialState: State
    let userService: UserServiceType
    let postService: PostServiceType
    
    init(mode: PostEditViewMode,
         userService: UserServiceType,
         postService: PostServiceType
    ) {
        self.userService = userService
        self.postService = postService
        self.mode = mode
        switch mode {
        case .new:
            self.initialState = State(images: [], region: "")
        case .edit(let post):
            self.initialState = State(images: [], caption: post.caption, region: post.location, price: post.mealBudget, star: post.star)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.currentUser
            .map { Mutation.setUser($0) }
        switch mode {
        case .new:
            return .merge(mutation, user)
        case .edit(let post):
            let images = self.urlToImageWithkf(urls: post.images).map { Mutation.setImages($0) }
            return .merge(mutation, user, images)
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .imageUpload(let images):
            return Observable.just(Mutation.setImages(images))
        case .inputRegion(let region):
            return Observable.just(Mutation.setRegion(region))
        case .inputCaption(let caption):
            return Observable.just(Mutation.setCaption(caption))
        case .inputPrice(let price):
            return Observable.just(Mutation.setPrice(price))
        case .inputStar(let star):
            return Observable.just(Mutation.setStar(star))
        case .uploadPostButtonTapped:
            Analytics.logEvent("addPostButton_tap", parameters: nil)
            Analytics.logEvent(AnalyticsEventPostScore, parameters: [
                AnalyticsParameterScore: self.currentState.star
            ])
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.uploadPost(mode: self.mode, user: self.currentState.user,
                                images: self.currentState.images,
                                region: self.currentState.region,
                                price: self.currentState.price,
                                star: self.currentState.star,
                                caption: self.currentState.caption)
                    .map { Mutation.sendErrorMessage(!$0) },
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setUser(let user):
            newState.user = user
        case .sendErrorMessage(let isError):
            newState.isError = isError
        case .setRegion(let region):
            newState.region = region
        case .setCaption(let caption):
            newState.caption = caption
        case .setPrice(let price):
            newState.price = price
        case .setStar(let star):
            newState.star = star
        case .setValidation(let isValid):
            newState.isValid = isValid
        }
        return newState
    }
    
    func uploadPost(mode: PostEditViewMode, user: User, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool> {
        switch self.mode {
        case .new:
            return postService.createPost(user: user,
                                               images: images,
                                               region: region,
                                               price: price,
                                               star: star,
                                               caption: caption)
        case .edit(let post):
            return postService.updatePost(originalPost: post,
                                               images: images,
                                               region: region,
                                               price: price,
                                               star: star,
                                               caption: caption)
        }
    }
    
    func buttonValidation(images: [UIImage], caption: String, region: String, price: String) -> Bool {
        guard caption.isEmpty || caption == "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)" || images.isEmpty || region.isEmpty || price.isEmpty else { return true }
        return false
    }
    
    func urlToImageWithkf(urls: [URL?]) -> Observable<[UIImage]> {
        return Observable.create { observer in
            var images = [UIImage]()
            let dispatchGroup = DispatchGroup()
            urls.forEach { url in
                guard let url = url else { return }
                dispatchGroup.enter()
                KingfisherManager.shared.retrieveImage(with: url, options: .none) { result in
                    switch result {
                    case .success(let imageResult):
                        let image = imageResult.image
                        images.append(image)
                        dispatchGroup.leave()
                    case .failure(let error):
                        print(error)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .global()) {
                observer.onNext(images)
            }
            return Disposables.create()
        }
    }
}
