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

class AddPostViewController: UIViewController, StoryboardView, StoryboardBased {
    
    // UIComponent
    
    @IBOutlet weak var addScrollView: UIScrollView!
    @IBOutlet weak var uploadPostButton: UIButton!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var starSlider: StarSlider!
    
    let activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    let placeholderString: String = "맛있게 하셨던 식사에 대해서 알려주세요\n시간, 가게이름, 메뉴, 간단한 레시피 등\n추천하신 이유를 적어주세요:)"
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "포스트 작성"
        uploadPostButton.makeShadow()
        captionView.makeShadow()
        regionView.makeShadow()
        priceView.makeShadow()
        starView.makeShadow()
        captionTextView.layer.cornerRadius = 15
        captionTextView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        captionTextView.delegate = self
        captionTextView.textColor = UIColor.darkGray
        priceTextField.delegate = self
        regionTextField.delegate = self
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
    }
 
    func bind(reactor: AddPostReactor) {
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, isLoading in
                isLoading ? owner.activityIndicator.startAnimating() : owner.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isError }
            .bind(onNext: { isError in
                guard let isError = isError else { return }
                if isError {
                    errorAlert(selfView: self, errorMessage: "포스트 업로드에 실패했습니다.", completion: { })
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.caption }
        .distinctUntilChanged()
        .bind(to: self.captionTextView.rx.text)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.region }
        .distinctUntilChanged()
        .bind(to: self.regionTextField.rx.text)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.star }
        .distinctUntilChanged()
        .bind(to: self.starSlider.rx.starPoint)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.price }
        .map { $0 == 0 ? "": "\($0)" }
        .distinctUntilChanged()
        .bind(to: self.priceTextField.rx.text)
        .disposed(by: disposeBag)
        
        regionTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.inputRegion($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        captionTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.inputCaption($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.inputPrice(Int($0) ?? 0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        starSlider.rx.value
            .map { Int(round($0)) }
            .distinctUntilChanged()
            .map { Reactor.Action.inputStar($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        uploadPostButton.rx.tap
            .take(1)
            .map { AddPostReactor.Action.uploadPostButtonTapped }
            .bind(onNext: { tap in
                reactor.action.onNext(tap)
            })
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.images }
                .distinctUntilChanged(),
            reactor.state.map { $0.region }
                .distinctUntilChanged(),
            reactor.state.map { $0.caption }
                .distinctUntilChanged(),
            reactor.state.map { $0.price }
                .map { "\($0)"}
                .distinctUntilChanged()) { images, region, caption, price -> Bool in
                    return reactor.buttonValidation(images: images, caption: caption, region: region, price: price)
                }
                .distinctUntilChanged()
                .bind(to: uploadPostButton.rx.isEnabled)
                .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.addScrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: rx.disposeBag)
       
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
            if textView.text == placeholderString {
                textView.text = nil
            }
            textView.textColor = UIColor.black
        }
        addScrollView.scrollToBottom()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderString
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
