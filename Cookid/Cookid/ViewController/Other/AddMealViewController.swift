//
//  AddMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AddMealViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dimmingButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var isDineInSwitch: UISwitch!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var announceLabel: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var mealtimeTF: UITextField!
    @IBOutlet weak var mealnameTF: UITextField!
    @IBOutlet weak var mealpriceTF: UITextField!
    @IBOutlet weak var validationView: UIButton!
    
    // pickers
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
    
    lazy var mealTimePicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        picker.backgroundColor = .white
        return picker
    }()
    
    // properties
    
    var meal: Meal?
    var viewModel: AddMealViewModel!
    var selectedPhoto: Bool = false
    var selectedPictrue: Bool = false
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initialSetting()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        scrollView.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        addPhotoButton.layer.cornerRadius = 8
        addPictureButton.layer.cornerRadius = 8
        dateTF.inputView = datePicker
        dateTF.inputView?.backgroundColor = .white
        mealtimeTF.inputView = mealTimePicker
        settingPickerInTextField(dateTF)
        settingPickerInTextField(mealtimeTF)
        self.mealtimeTF.text = MealTime.breakfast.rawValue
    }
    
    private func initialSetting() {
        guard let meal = meal else { return }
        dateTF.text = convertDateToString(format: "MM월 dd일", date: meal.date)
        mealtimeTF.text = meal.mealTime.rawValue
        mealnameTF.text = meal.name
        mealpriceTF.text = intToString(meal.price)
        isDineInSwitch.isOn = mealTypeToBool(meal.mealType)
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
        doneView.backgroundColor = .white
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

    
    // MARK: - Binding
    
    func bindViewModel() {
     
        dimmingButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addPhotoButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                
                selectedPhoto.toggle()
                
                if selectedPhoto {
                    UIView.animate(withDuration: 0.3) {
                        self.addPictureButton.alpha = 0
                        self.addPictureButton.isHidden = true
                        self.announceLabel.text = "음식을 중앙에 놓고 찍어주세요:)"
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.addPictureButton.alpha = 1
                        self.addPictureButton.isHidden = false
                        self.announceLabel.text = "사진이 없으시다면 이미지로 넣어보세요:)"
                    }
                }
                
            })
            .disposed(by: rx.disposeBag)
        
        addPictureButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                
                selectedPictrue.toggle()
                
                if selectedPictrue {
                    UIView.animate(withDuration: 0.3) {
                        self.addPhotoButton.alpha = 0
                        self.addPhotoButton.isHidden = true
                        self.announceLabel.text = "원하시는 이미지를 선택해 주세요:)"
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.addPhotoButton.alpha = 1
                        self.addPhotoButton.isHidden = false
                        self.announceLabel.text = "사진으로 추가하시면 추천 자동완성됩니다:)"
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        Observable.of(MealTime.allCases.map { $0.rawValue })
            .bind(to: mealTimePicker.rx.itemTitles) { row, element in
                return element
            }
            .disposed(by: rx.disposeBag)
        
        datePicker.rx.date
            .subscribe(onNext: { [unowned self] date in
                self.dateTF.text = convertDateToString(format: "yyyy년 MM월 dd일", date: date)
                self.viewModel.input.mealDate.onNext(date)
            })
            .disposed(by: rx.disposeBag)
        
        mealTimePicker.rx.itemSelected
            .subscribe(onNext: { [unowned self] row, item in
                self.mealtimeTF.text = MealTime.allCases[row].rawValue
                self.viewModel.input.mealTime.onNext(MealTime.allCases[row])
            })
            .disposed(by: rx.disposeBag)
        
        isDineInSwitch.rx.isOn
            .do(onNext: { [unowned self] isOn in
                if isOn {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 0
                        priceStackView.isHidden = true
                        self.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        self.validationView.tintColor = .red
                    }
                    self.viewModel.input.mealType.onNext(.dineIn)
                    self.viewModel.input.mealPrice.onNext("")
                    self.mealpriceTF.text = ""
                } else {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 1
                        priceStackView.isHidden = false
                    }
                    self.viewModel.input.mealType.onNext(.dineOut)
                    scrollView.scrollToBottom()
                }
            })
            .subscribe(onNext: { [unowned self] isOn in
                self.viewModel.input.isDineIn.onNext(isOn)
            })
            .disposed(by: rx.disposeBag)
        
        mealpriceTF.rx.text.orEmpty
            .do(onNext: { [unowned self] text in
                if viewModel.mealService.validationNum(text: text) {
                    UIView.animate(withDuration: 0.3) {
                        self.validationView.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        self.validationView.tintColor = .systemGreen
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        self.validationView.tintColor = .red
                    }
                }
            })
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.input.mealPrice.onNext(text)
            })
            .disposed(by: rx.disposeBag)
        
        mealnameTF.rx.text.orEmpty
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.input.mealName.onNext(text)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.validation
            .drive(completionButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.newMeal
            .drive(onNext: { meal in
                print(meal.name)
                print(meal.mealTime)
                print(meal.mealType)
                print(meal.price)
            })
            .disposed(by: rx.disposeBag)
        
        completionButton.rx.tap
            .subscribe(onNext: {
                
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
