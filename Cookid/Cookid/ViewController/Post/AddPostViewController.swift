//
//  AddPostViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
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
    
    let loadingView = AnimationView(name: "loadingImage").then {
        $0.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
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
        captionTextView.text = "맛있게 하셨던 식사에 대해서 알려주세요:)\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)"
        captionTextView.textColor = UIColor.darkGray
        priceTextField.delegate = self
        regionTextField.delegate = self
    }
    
    func bind(reactor: AddPostReactor) {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.addScrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: rx.disposeBag)
        
        uploadPostButton.rx.tap
            .map { AddPostReactor.Action.uploadPostButtonTapped }
            .bind(to: reactor.action)
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
        
        Observable.combineLatest(
            reactor.state.map { $0.imageURLs }
                .distinctUntilChanged(),
            regionTextField.rx.text.orEmpty
                .distinctUntilChanged(),
            captionTextView.rx.text.orEmpty
                .distinctUntilChanged()) { urls, region, caption -> Bool in
                    guard urls.isEmpty,
                          caption == "",
                          region == "" else { return true }
                    return false
                }
                .distinctUntilChanged()
                .map { Reactor.Action.buttonValidation($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.images },
            regionTextField.rx.text.orEmpty,
            captionTextView.rx.text.orEmpty,
            priceTextField.rx.text.orEmpty,
            starSlider.rx.value.map { Int(round($0)) }) { images, region, caption, price, star -> Post in
                    return Post(postID: reactor.postID, user: reactor.userService.user(), images: images, star: star, caption: caption, mealBudget: price, location: region)
                }
                .map { Reactor.Action.makePost($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validation }
            .distinctUntilChanged()
            .bind(to: self.uploadPostButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
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
