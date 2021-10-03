//
//  AddPostViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxKeyboard
import ReactorKit
import Lottie

class AddPostViewController: UIViewController, StoryboardView, StoryboardBased {
    
    // UIComponent
    
    @IBOutlet weak var addScrollView: UIScrollView!
    @IBOutlet weak var uploadPostButton: UIButton!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var starView: UIView!
    
    //    let loadingView = AnimationView(name: "loadingImage").then {
    //        $0.snp.makeConstraints { make in
    //            make.centerX.equalToSuperview()
    //            make.centerY.equalToSuperview()
    //        }
    //    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "포스트 작성"
        uploadPostButton.makeShadow()
        captionView.makeShadow()
        regionView.makeShadow()
        priceView.makeShadow()
        starView.makeShadow()
        captionTextView.layer.cornerRadius = 15
        captionTextView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        captionTextView.delegate = self
        captionTextView.text = "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)"
        captionTextView.textColor = UIColor.darkGray
        priceTextField.delegate = self
        regionTextField.delegate = self
    }
    
    func bind(reactor: AddPostReactor) {
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.newPost }
            .bind(onNext: { post in
                guard let post = post else { return }
                print(post)
            })
            .disposed(by: disposeBag)
        
        uploadPostButton.rx.tap
            .map { AddPostReactor.Action.uploadPostButtonTapped }
            .do(onNext: { reactor.action.onNext($0) })
            .bind(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        starSlider.rx.value
            .map { Int(round($0)) }
            .distinctUntilChanged()
            .bind { [unowned self] value in
                for index in 0...5 {
                    if let tagView = self.view.viewWithTag(index) as? UIImageView {
                        if index <= value {
                            tagView.image = UIImage(systemName: "star.fill")
                        } else {
                            tagView.image = UIImage(systemName: "star")
                        }
                    }
                }
                print(value)
            }
            .disposed(by: rx.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.addScrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: rx.disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.images }
                .distinctUntilChanged(),
            regionTextField.rx.text.orEmpty
                .distinctUntilChanged(),
            captionTextView.rx.text.orEmpty
                .distinctUntilChanged(),
            priceTextField.rx.text.orEmpty
                .distinctUntilChanged()) { images, region, caption, price -> Bool in
            return self.buttonValidation(images: images, caption: caption, region: region, price: price)
        }
        .distinctUntilChanged()
        .bind(to: uploadPostButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        let postObservable = Observable.combineLatest(
            reactor.userService.user(),
            reactor.state.map { $0.images }
                .distinctUntilChanged(),
            regionTextField.rx.text.orEmpty
                .distinctUntilChanged(),
            captionTextView.rx.text.orEmpty
                .distinctUntilChanged(),
            priceTextField.rx.text.orEmpty
                .distinctUntilChanged(),
            starSlider.rx.value
                .map { Int(round($0)) }
                .distinctUntilChanged(), resultSelector: { user, images, place, caption, price, star -> Post in
                    let newPost = Post(postID: reactor.postID, user: user, images: images, star: star, caption: caption, mealBudget: Int(price) ?? 0, location: place)
                    return newPost
                })
        
        postObservable.map { Reactor.Action.makePost($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func buttonValidation(images: [UIImage], caption: String, region: String, price: String) -> Bool {
        guard caption.isEmpty || caption == "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)" || images.isEmpty || region.isEmpty || price.isEmpty else { return true }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPostImageCV" {
            guard let vc = segue.destination as? AddPostImageCollectionViewController else { return }
            vc.reactor = reactor
        }
    }
    
}

extension AddPostViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        addScrollView.scrollToBottom()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)"
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
