//
//  AddMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import RxKeyboard
import Then
import SnapKit

class AddMealViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StoryboardView, StoryboardBased {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dimmingButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var isDineInSwitch: UISwitch!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var announceLabel: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var mealtimeTF: UITextField!
    @IBOutlet weak var mealnameTF: UITextField!
    @IBOutlet weak var mealpriceTF: UITextField!
    @IBOutlet weak var validationView: UIButton!
    @IBOutlet weak var updateAnnouce: UILabel!
    
    // pickers
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        picker.locale = Locale(identifier: "ko-KR")
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
    
    lazy var mealTimePicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        picker.backgroundColor = .systemBackground
        return picker
    }()
    
    let imagePicker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    // properties
    
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: MainCoordinator?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    // MARK: - UI
    
    private func makeConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configureUI() {
        scrollView.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        addPhotoButton.layer.cornerRadius = 8
        addPhotoButton.layer.masksToBounds = true
        dateTF.inputView = datePicker
        dateTF.inputView?.backgroundColor = .systemBackground
        mealtimeTF.inputView = mealTimePicker
        settingPickerInTextField(dateTF)
        settingPickerInTextField(mealtimeTF)
        dimmingButton.backgroundColor = .black
        scrollView.delegate = self
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
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: doneView.topAnchor, constant: 11).isActive = true
        doneButton.rightAnchor.constraint(equalTo: doneView.rightAnchor, constant: -11).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        textfield.inputAccessoryView = doneView
        
    }
    
    // MARK: - Action
    
    @objc func pickerDone() {
        dateTF.resignFirstResponder()
        mealtimeTF.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        let renderImage = selectedImage.resize(newWidth: self.view.frame.width)
        reactor?.action.onNext(Reactor.Action.image(renderImage))
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Binding
    
    func bind(reactor: AddMealReactor) {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        
        Observable.of(MealTime.allCases.map { $0.rawValue })
            .bind(to: mealTimePicker.rx.itemTitles) { _, element in
                return element
            }
            .disposed(by: disposeBag)
        
        bindStateWithView(reactor: reactor)
        bindActionWithButton(reactor: reactor)
        bindActionWithComponents(reactor: reactor)
        initialSetting(reactor: reactor)
    }
    
    // MARK: - initialSetting
    private func initialSetting(reactor: AddMealReactor) {
        switch reactor.mode {
        case .new:
            announceLabel.text = "위의 빈 화면을 눌러 이미지를 넣어보세요:)"
            updateAnnouce.text = "식사 기록이 완료되셨나요?"
            deleteButton.isHidden = true
        case .edit(_):
            announceLabel.text = "이미지를 수정하시려면 사진을 누르세요:)"
            updateAnnouce.text = "수정이 완료되셨나요?"
            deleteButton.isHidden = false
            deleteButton.tintColor = #colorLiteral(red: 0.833554848, green: 0.2205436249, blue: 0.1735619552, alpha: 1)
            completionButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            completionButton.tintColor = #colorLiteral(red: 0.2396557123, green: 0.7154314493, blue: 0.5069640082, alpha: 1)
        }
    }
    
    // MARK: - bindActionWithComponents
    private func bindActionWithComponents(reactor: AddMealReactor) {
        
        datePicker.rx.date
            .map { Reactor.Action.date($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mealTimePicker.rx.itemSelected
            .map { Reactor.Action.mealTime(MealTime.allCases[$0.0]) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isDineInSwitch.rx.isOn
            .do(onNext: { [unowned self] isOn in
                if isOn {
                    UIView.animate(withDuration: 0.3) {
                        self.priceStackView.alpha = 0
                        self.priceStackView.isHidden = true
                        self.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        self.validationView.tintColor = .red
                    }
                    reactor.action.onNext(Reactor.Action.price(""))
                    self.mealpriceTF.text = ""
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.priceStackView.alpha = 1
                        self.priceStackView.isHidden = false
                    }
                }
            })
            .map { isOn -> MealType in
                isOn ? .dineIn : .dineOut
            }
            .map { Reactor.Action.mealType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mealpriceTF.rx.text
            .map { Reactor.Action.price($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mealnameTF.rx.text.orEmpty
            .map { Reactor.Action.name($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: - bindActionWithButton
    private func bindActionWithButton(reactor: AddMealReactor) {
        
        deleteButton.rx.tap
            .map { Reactor.Action.delete }
            .bind(onNext: { [unowned self] action in
                let alert = UIAlertController(title: "삭제하기", message: "식사를 삭제하시겠어요? 삭제 후에는 복구가 불가능합니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "삭제", style: .default) { _ in
                    reactor.action.onNext(action)
                    self.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        dimmingButton.rx.tap
            .bind(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        addPhotoButton.rx.tap
            .bind(onNext: { [unowned self] in
                let alertController = UIAlertController(title: "메뉴 사진 업로드", message: "어디에서 메뉴의 사진을 업로드 할까요?", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                imagePicker.delegate = self
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let photoAction = UIAlertAction(title: "사진 라이브러리", style: .default) { _ in
                        imagePicker.sourceType = .photoLibrary
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                    alertController.addAction(photoAction)
                }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let cameralAction = UIAlertAction(title: "카메라", style: .default) { _ in
                        imagePicker.sourceType = .camera
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                    alertController.addAction(cameralAction)
                }
                let pictureAction = UIAlertAction(title: "식사 이미지", style: .default) { _ in
                    let cvc = PictureSelectViewController()
                    cvc.reactor = reactor
                    cvc.modalTransitionStyle = .crossDissolve
                    cvc.modalPresentationStyle = .automatic
                    self.presentPanModal(cvc)
                }
                alertController.addAction(pictureAction)
                present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        completionButton.rx.tap
            .map { Reactor.Action.upload }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - bindStateWithView
    private func bindStateWithView(reactor: AddMealReactor) {
        
        reactor.state.map { $0.isError }
        .bind(onNext: { [unowned self] isError in
            guard let isError = isError else { return }
            isError ? errorAlert(selfView: self, errorMessage: "식사를 추가 작업에 실패했습니다ㅠㅠ") {
                self.dismiss(animated: true, completion: nil)
            }
            : self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
  
        reactor.state.map { $0.priceValid }
        .bind(onNext: { [unowned self] isValid in
            guard let isValid = isValid else {
                self.validationView.isHidden = true
                return }
            if isValid {
                UIView.animate(withDuration: 0.3) {
                    self.validationView.isHidden = false
                    self.validationView.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    self.validationView.tintColor = .systemGreen
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.validationView.isHidden = false
                    self.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    self.validationView.tintColor = .red
                }
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.image }
        .bind { [unowned self] image in
            guard let image = image else { return }
            self.addPhotoButton.setImage(image, for: .normal)
            self.addPhotoButton.backgroundColor = .systemBackground
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
        .bind { [unowned self] date in
            self.dateTF.text = convertDateToString(format: "yyyy년 MM월 dd일", date: date)
            self.datePicker.setDate(date, animated: false)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.mealTime }
        .bind { [unowned self] mealTime in
            let mealtimeArr = MealTime.allCases.firstIndex(of: mealTime)!
            self.mealTimePicker.selectRow(mealtimeArr, inComponent: 0, animated: false)
            self.mealtimeTF.text = mealTime.rawValue
        }
        .disposed(by: disposeBag)
        
        self.mealnameTF.text = reactor.currentState.name
        self.mealpriceTF.text = reactor.currentState.price
        
        reactor.state.map { $0.mealType }
        .bind(onNext: { [unowned self] mealType in
            self.isDineInSwitch.setOn(mealType == .dineIn ? true : false, animated: false)
        })
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.name },
            reactor.state.map { $0.priceValid },
            reactor.state.map { $0.image },
            reactor.state.map { $0.mealType }) { name, valid, image, type -> Bool in
            if type == .dineOut {
                guard name != "",
                      valid ?? false,
                      image != nil else { return false }
            } else {
                guard reactor.currentState.name != "",
                      reactor.currentState.image != nil else { return false }
            }
            return true
        }
        .bind(to: completionButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
    }
    
}
