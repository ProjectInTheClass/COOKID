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
import Kingfisher
import RxKeyboard

class AddMealViewController: UIViewController, ViewModelBindable, StoryboardBased, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    // properties
    
    var meal: Meal?
    var newMeal: Meal?
    var viewModel: AddMealViewModel!
    let imagePicker = UIImagePickerController()
    
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
        addPhotoButton.layer.masksToBounds = true
        dateTF.inputView = datePicker
        dateTF.inputView?.backgroundColor = .systemBackground
        mealtimeTF.inputView = mealTimePicker
        settingPickerInTextField(dateTF)
        settingPickerInTextField(mealtimeTF)
        self.mealtimeTF.text = MealTime.breakfast.rawValue
        dimmingButton.backgroundColor = .black
    }
    
    private func initialSetting() {
        if let meal = self.meal {
            announceLabel.text = "이미지를 수정하시려면 사진을 누르세요:)"
            updateAnnouce.text = "수정이 완료되셨나요?"
            deleteButton.isHidden = false
            deleteButton.tintColor = #colorLiteral(red: 0.833554848, green: 0.2205436249, blue: 0.1735619552, alpha: 1)
            completionButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            completionButton.tintColor = #colorLiteral(red: 0.2396557123, green: 0.7154314493, blue: 0.5069640082, alpha: 1)
            dateTF.text = convertDateToString(format: "yyyy년 MM월 dd일", date: meal.date)
            datePicker.setDate(meal.date, animated: false)
            mealtimeTF.text = meal.mealTime.rawValue
            mealnameTF.text = meal.name
            mealpriceTF.text = String(describing: meal.price)
            isDineInSwitch.isOn = mealTypeToBool(meal.mealType)
        } else {
            announceLabel.text = "위의 빈 화면을 눌러 이미지를 넣어보세요:)"
            updateAnnouce.text = "식사 기록이 완료되셨나요?"
            deleteButton.isHidden = true
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
        viewModel.input.mealImage.accept(selectedImage)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Binding
    
    func bindViewModel() {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: rx.disposeBag)
        
        dimmingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if meal != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.viewModel.mealService.deleteImage(mealID: self.viewModel.input.mealID)
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: rx.disposeBag)
        
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
                    var cvc = PictureSelectViewController()
                    cvc.bind(viewModel: self.viewModel)
                    cvc.modalTransitionStyle = .crossDissolve
                    cvc.modalPresentationStyle = .automatic
                    self.presentPanModal(cvc)
                }
                alertController.addAction(pictureAction)
                
                present(alertController, animated: true, completion: nil)
                
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let alert = UIAlertController(title: "삭제하기", message: "식사를 삭제하시겠어요? 삭제 후에는 복구가 불가능합니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "삭제", style: .default) { _ in
                    guard let meal = self.meal else { return }
                    self.viewModel.mealService.deleteMeal(meal: meal)
                    self.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        Observable.of(MealTime.allCases.map { $0.rawValue })
            .bind(to: mealTimePicker.rx.itemTitles) { _, element in
                return element
            }
            .disposed(by: rx.disposeBag)
        
        datePicker.rx.date
            .subscribe(onNext: { [unowned self] date in
                self.dateTF.text = convertDateToString(format: "yyyy년 MM월 dd일", date: date)
                self.viewModel.input.mealDate.accept(date)
                
            })
            .disposed(by: rx.disposeBag)
        
        mealTimePicker.rx.itemSelected
            .subscribe(onNext: { [unowned self] row, _ in
                self.mealtimeTF.text = MealTime.allCases[row].rawValue
                self.viewModel.input.mealTime.accept(MealTime.allCases[row])
            })
            .disposed(by: rx.disposeBag)
        
        isDineInSwitch.rx.isOn
            .subscribe(onNext: { [unowned self] isOn in
                if isOn {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 0
                        priceStackView.isHidden = true
                        self.validationView.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        self.validationView.tintColor = .red
                    }
                    self.viewModel.input.mealType.accept(.dineIn)
                    self.viewModel.input.mealPrice.accept("")
                    self.mealpriceTF.text = ""
                } else {
                    UIView.animate(withDuration: 0.3) {
                        priceStackView.alpha = 1
                        priceStackView.isHidden = false
                    }
                    self.viewModel.input.mealType.accept(.dineOut)
                    scrollView.scrollToBottom()
                }
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
                self.viewModel.input.mealPrice.accept(text)
            })
            .disposed(by: rx.disposeBag)
        
        mealnameTF.rx.text.orEmpty
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.input.mealName.accept(text)
            })
            .disposed(by: rx.disposeBag)
        
        // MARK: - output
        
        viewModel.input.mealImage
            .bind { [unowned self] image in
                self.addPhotoButton.setImage(image, for: .normal)
                self.addPhotoButton.backgroundColor = .systemBackground
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.validation
            .drive(completionButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.newMeal
            .bind { [unowned self] meal in
                self.newMeal = meal
            }
            .disposed(by: rx.disposeBag)
        
        // MARK: - initialSetting For Publish
        
        if let meal = self.meal {
            viewModel.input.mealImage.accept(meal.image)
            viewModel.input.mealTime.accept(meal.mealTime)
        }

        // MARK: - Completion Button
        
        completionButton.rx.tap
            .bind { [unowned self] _ in
                guard let newMeal = self.newMeal else {
                    return }
                if self.meal != nil {
                    self.viewModel.mealService.update(updateMeal: newMeal) { success in
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    self.viewModel.mealService.create(meal: newMeal) { success in
                        if success {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            .disposed(by: rx.disposeBag)
    }
}
