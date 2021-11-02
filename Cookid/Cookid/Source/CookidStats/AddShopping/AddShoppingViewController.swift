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

class AddShoppingViewController: UIViewController, View {
    
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
        $0.distribution = .fill
    }
    
    lazy var wholeStackView = UIStackView(arrangedSubviews: [titleStackView, dateStackView, priceStackView, buttonStack]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 30.0
        $0.distribution = .fillEqually
    }
    
    // MARK: - Property
    
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: MainCoordinator?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingPickerInTextField(dateTextField)
    }
    
    // MARK: - Function
    
    private func configureUI() {
        view.addSubview(dimmingButton)
        dimmingButton.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(backgroundView.snp.width)
        }
        backgroundView.makeShadow()
        
        backgroundView.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.left.equalTo(30)
            make.bottom.equalTo(-30)
            make.right.equalTo(-30)
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
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] frame in
                backgroundView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview().offset(-frame/4)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(view).multipliedBy(0.8)
                    make.height.equalTo(backgroundView.snp.width).multipliedBy(1.1 / 1.0)
                }
            })
            .disposed(by: rx.disposeBag)
        
        dimmingButton.rx.tap
            .bind { [unowned self] in
                self.dismiss(animated: true)
            }
            .disposed(by: rx.disposeBag)
        
        datePicker.rx.date
            .map { .inputDate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
        .withUnretained(self)
        .bind(onNext: { owner, date in
            owner.dateTextField.text = convertDateToString(format: "yyyy년 MM월 dd일", date: date)
            owner.datePicker.setDate(date, animated: false)
        })
        .disposed(by: disposeBag)
        
        priceTextField.rx.text.orEmpty
            .map { .inputTotalPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        reactor.state.map { $0.isPriceValid }
        .withUnretained(self)
        .bind(onNext: { owner, isValid in
            guard let isValid = isValid else { return }
            if isValid {
                UIView.animate(withDuration: 0.3) {
                    owner.validationView.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    owner.validationView.tintColor = .systemGreen
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    owner.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    owner.validationView.tintColor = .red
                }
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.totalPrice }
        .map { String(describing: $0) }
        .bind(to: priceTextField.rx.text)
        .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator?.presentDeleteAlert(reactor: reactor)
            })
            .disposed(by: rx.disposeBag)
        
        saveButton.rx.tap
            .map { .uploadButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: rx.disposeBag)
        
        reactor.state.map { $0.isError }
        .withUnretained(self)
        .bind(onNext: { owner, isError in
            guard let isError = isError else { return }
            isError ? errorAlert(selfView: owner, errorMessage: "작업에 실패했습니다.", completion: {  }) :
            owner.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
        initialSetting(reactor: reactor)
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
