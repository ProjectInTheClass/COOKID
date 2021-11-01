//
//  AddTodayMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/11.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Then
import SnapKit
import RxKeyboard

class AddTodayMealViewController: UIViewController, StoryboardBased, StoryboardView {
    
    @IBOutlet weak var breakfastTextField: UITextField!
    @IBOutlet weak var breakfastValidation: UIImageView!
    
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var lunchValidation: UIImageView!
    
    @IBOutlet weak var dinnerTextField: UITextField!
    @IBOutlet weak var dinnerValidation: UIImageView!
    
    @IBOutlet weak var dimmingButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundViewCenterY: NSLayoutConstraint!
     
    @IBOutlet weak var completeButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        backgroundView.makeShadow()
        dimmingButton.backgroundColor = .black
    }
    
    private func makeConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    func bind(reactor: AddTodayReactor) {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                var shouldMoveViewUp: Bool = false
                let visibleRange = view.frame.height - height
                let bottomOfView = backgroundView.frame.maxY
                if bottomOfView > visibleRange {
                    shouldMoveViewUp = true
                }
                if shouldMoveViewUp {
                    self.backgroundViewCenterY.constant = visibleRange - bottomOfView - 10
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.breakfastValidation }
        .withUnretained(self)
        .bind { owner, isValid in
            guard let isValid = isValid else {
                owner.breakfastValidation.isHidden = true
                return
            }
            self.setImageWithValidation(isValid: isValid, target: owner.breakfastValidation)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.lunchValidation }
        .withUnretained(self)
        .bind { owner, isValid in
            guard let isValid = isValid else {
                owner.lunchValidation.isHidden = true
                return
            }
            self.setImageWithValidation(isValid: isValid, target: owner.lunchValidation)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.dinnerValidation }
        .withUnretained(self)
        .bind { owner, isValid in
            guard let isValid = isValid else {
                owner.dinnerValidation.isHidden = true
                return
            }
            self.setImageWithValidation(isValid: isValid, target: owner.dinnerValidation)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
        .withUnretained(self)
        .bind { owner, isLoading in
            isLoading ? owner.activityIndicator.startAnimating() : owner.activityIndicator.stopAnimating()
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isError }
        .withUnretained(self)
        .bind { owner, isError in
            guard let isError = isError else { return }
            isError ? errorAlert(selfView: owner, errorMessage: "오늘의 식사를 업로드하는데 실패했습니다 😭", completion: {
                self.dismiss(animated: true, completion: nil)
            }) : owner.dismiss(animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
        
        breakfastTextField.rx.text
            .map { Reactor.Action.breakfastPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        lunchTextField.rx.text
            .map { Reactor.Action.lunchPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dinnerTextField.rx.text
            .map { Reactor.Action.dinnerPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dimmingButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .map { Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func setImageWithValidation(isValid: Bool, target: UIImageView) {
        
        target.isHidden = false

        if isValid {
            UIView.animate(withDuration: 0.3) {
                target.image = UIImage(systemName: "checkmark.circle.fill")
                target.tintColor = .systemGreen
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                target.image = UIImage(systemName: "minus.circle")
                target.tintColor = .red
            }
            
        }
    }
}
