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
    
    var meal: Meal?
    
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
  
    // pickers
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        dp.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        dp.locale = Locale(identifier: "ko-KR")
        dp.datePickerMode = .date
        dp.maximumDate = Date()
        dp.backgroundColor = .white
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
        picker.subviews.first?.subviews.last?.backgroundColor = #colorLiteral(red: 1, green: 0.870105389, blue: 0.5648625297, alpha: 0.5029385385)
        return picker
    }()
    
    // properties
    
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
    
    @objc func dateChanged() {
        dateTF.text = "\(datePicker.date)"
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        Observable.of(MealTime.allCases.map { $0.rawValue })
            .bind(to: mealTimePicker.rx.itemTitles) { [unowned self] row, element in
                self.mealtimeTF.text = element
                return element
            }
            .disposed(by: rx.disposeBag)
            
        
        
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
        
        completionButton.rx.tap
            .subscribe(onNext: {
                print("completionButton tapped")
            })
            .disposed(by: rx.disposeBag)
        
        isDineInSwitch.rx.isOn
            .subscribe(onNext: { [unowned self] isOn in
                
                if isOn {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 0
                        priceStackView.isHidden = true
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 1
                        priceStackView.isHidden = false
                    }
                    scrollView.scrollToBottom()
                }
            })
            .disposed(by: rx.disposeBag)
        
    }
    
}
