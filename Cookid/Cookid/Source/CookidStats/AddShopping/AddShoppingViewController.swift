//
//  AddShoppingViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/25.
//

import UIKit
import SnapKit
import Then
import RxKeyboard
import RxSwift
import ReactorKit

class AddShoppingViewController: UIViewController, StoryboardView {
    
    // MARK: - UI
    
    let dimmingButton = UIButton().then {
        $0.backgroundColor = .black
        $0.alpha = 0.6
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = DefaultStyle.Color.bgTint
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = DefaultStyle.Color.labelTint
        $0.text = "쇼핑 기록  🛒"
    }
    
    let subtitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = DefaultStyle.Color.labelTint
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.text = "오늘은 얼마를 사용하셨나요?"
    }
    
    lazy var titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = DefaultStyle.Color.labelTint
        $0.text = "📆 날짜"
    }
    
    let dateTextField = UITextField().then {
        $0.placeholder = convertDateToString(format: "yyyy년 MM월 dd일", date: Date())
        $0.font = .systemFont(ofSize: 15, weight: .light)
        $0.textColor = DefaultStyle.Color.tint
    }
    
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        dp.locale = Locale(identifier: "ko-KR")
        dp.datePickerMode = .date
        dp.maximumDate = Date()
        if #available(iOS 13.4, *) {
            dp.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return dp
    }()
    
    lazy var dateStackView = UIStackView(arrangedSubviews: [dateLabel, dateTextField]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 15
        $0.distribution = .fillProportionally
    }
    
    let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = DefaultStyle.Color.labelTint
        $0.text = "💸 금액"
    }
    
    let priceTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.font = .systemFont(ofSize: 15, weight: .light)
        $0.placeholder = "숫자만 입력해 주세요:)"
        $0.textColor = DefaultStyle.Color.tint
    }
    
    let validationView = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)
        let image = UIImage(systemName: "minus.circle", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.tintColor = .red
    }
    
    lazy var validationStackView = UIStackView(arrangedSubviews: [priceTextField, validationView]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 5
        $0.distribution = .fill
    }
    
    lazy var priceStackView = UIStackView(arrangedSubviews: [priceLabel, validationStackView]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 15
        $0.distribution = .fill
    }
    
    let updateAnnouce = UILabel().then {
        $0.text = "쇼핑 기록이 완료되셨나요?"
        $0.textColor = DefaultStyle.Color.labelTint
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        $0.textAlignment = .right
    }
    
    let saveButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .systemYellow
    }
    
    let deleteButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)
        let image = UIImage(systemName: "trash.circle.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .systemRed
    }
    
    lazy var buttonStack = UIStackView(arrangedSubviews: [updateAnnouce, deleteButton, saveButton]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10.0
        $0.distribution = .fillProportionally
    }
    
    lazy var wholeStackView = UIStackView(arrangedSubviews: [titleStackView, dateStackView, priceStackView, buttonStack]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 20.0
        $0.distribution = .fillEqually
    }
    
    // MARK: - Property
    
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: MainCoordinator?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        settingPickerInTextField(dateTextField)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bottomOfView = backgroundView.frame.origin.y + backgroundView.frame.height
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let visibleRange = view.frame.height - height
                if bottomOfView > visibleRange {
                    let value = visibleRange - bottomOfView - 20
                    backgroundView.snp.updateConstraints { make in
                        make.centerY.equalToSuperview().offset(value)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: - Function
    
    private func makeConstraints() {
        view.addSubview(dimmingButton)
        dimmingButton.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.75)
            make.height.equalTo(backgroundView.snp.width).multipliedBy(1.1)
        }
        backgroundView.makeShadow()
        backgroundView.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.left.equalTo(25)
            make.bottom.equalTo(-25)
            make.right.equalTo(-25)
        }
    }
    
    private func settingPickerInTextField(_ textfield: UITextField) {
        let buttonImage = UIImage(systemName: "checkmark.circle.fill")
        let doneButton = UIButton()
        doneButton.setImage(buttonImage, for: .normal)
        doneButton.addTarget(self, action: #selector(pickerDone), for: .touchUpInside)
        doneButton.contentVerticalAlignment = .fill
        doneButton.contentHorizontalAlignment = .fill
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        doneButton.tintColor = .systemGreen
        
        let doneView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45))
        doneView.backgroundColor = .systemBackground
        doneView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        
        doneView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(doneView).offset(11)
            make.right.equalTo(doneView).offset(-11)
            make.width.height.equalTo(36)
        }
        textfield.inputAccessoryView = doneView
        textfield.inputView = datePicker
        textfield.inputView?.backgroundColor = .systemBackground
    }
    
    @objc func pickerDone() {
        dateTextField.resignFirstResponder()
    }
    
    // MARK: - Binding ViewModel
    func bind(reactor: AddShoppingReactor) {
        
        // initial Setting 할 때는 binding 하는 타이밍이 중요하다.
        // reactor.state를 먼저 바인드 한 후에
        // 아래 action이 전달되도록 하자.그렇지 않으면 최소의 값이 들어오는게 아니라
        // action으로 전달된 값이 들어간다.
        
        initialSetting(reactor: reactor)
        
        reactor.state.map { $0.date }
        .bind(onNext: { [unowned self] date in
            self.dateTextField.text = convertDateToString(format: "yyyy년 MM월 dd일", date: date)
            self.datePicker.setDate(date, animated: false)
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPriceValid }
        .withUnretained(self)
        .bind(onNext: { owner, isValid in
            guard let isValid = isValid else {
                self.validationView.isHidden = true
                return }
            if isValid {
                UIView.animate(withDuration: 0.3) {
                    owner.validationView.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    owner.validationView.tintColor = .systemGreen
                    self.validationView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    owner.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    owner.validationView.tintColor = .red
                    self.validationView.isHidden = false
                }
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.totalPrice }
        .bind(to: priceTextField.rx.text)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isError }
        .withUnretained(self)
        .bind(onNext: { owner, isError in
            guard let isError = isError else { return }
            isError ? errorAlert(selfView: owner, errorMessage: "작업에 실패했습니다.", completion: {  }) :
            owner.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
        // reactorKit 문제인 것 같은데, datePicker가 그냥 View를 상속하면 제대로 작동하지 않는다.
        // StoryboardView를 상속하니 제대로 작동. 관련한거 수정 하도록 요청해보자?
        // 아니면 다른 뷰들이 스토리보드 베이스여서 그럴 수도 있다...
        datePicker.rx.date
            .map { Reactor.Action.inputDate($0) }
            .bind(onNext: { item in
                guard let reactor = self.reactor else { return }
                reactor.action.onNext(item)
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.presentDeleteAlert(root: self, reactor: reactor)
            })
            .disposed(by: rx.disposeBag)
        
        saveButton.rx.tap
            .map { .uploadButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        priceTextField.rx.text.orEmpty
            .map { Reactor.Action.inputTotalPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        dimmingButton.rx.tap
            .bind { [unowned self] in
                self.dismiss(animated: true)
            }
            .disposed(by: rx.disposeBag)

    }
    
    private func initialSetting(reactor: AddShoppingReactor) {
        switch reactor.mode {
        case .new:
            updateAnnouce.text = "쇼핑 기록이 완료되셨나요?"
            deleteButton.isHidden = true
        case .edit(_):
            updateAnnouce.text = "수정이 완료되셨나요?"
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)
            let image = UIImage(systemName: "pencil.circle.fill", withConfiguration: config)
            saveButton.setImage(image, for: .normal)
            saveButton.tintColor = .systemGreen
            deleteButton.isHidden = false
        }
    }
}
