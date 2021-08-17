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
    @IBOutlet weak var addPictureButton: UIButton!
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
    
    var meal: Meal? {
        didSet {
            print("meal is existence")
        }
    }
    var viewModel: AddMealViewModel!
    var selectedPhoto: Bool = false
    var selectedPictrue: Bool = false
    let mealID = UUID().uuidString
    let imagePicker = UIImagePickerController()
    var newMeal: Meal?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initialSetting()
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        scrollView.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        addPhotoButton.layer.cornerRadius = 8
        addPhotoButton.layer.masksToBounds = true
        addPictureButton.layer.cornerRadius = 8
        addPictureButton.layer.masksToBounds = true
        dateTF.inputView = datePicker
        dateTF.inputView?.backgroundColor = .white
        mealtimeTF.inputView = mealTimePicker
        settingPickerInTextField(dateTF)
        settingPickerInTextField(mealtimeTF)
        self.mealtimeTF.text = MealTime.breakfast.rawValue
        dimmingButton.backgroundColor = DefaultStyle.Color.tint
    }
    
    private func initialSetting() {
        if let meal = self.meal {
            updateAnnouce.text = "수정이 완료되셨나요?"
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: meal.image)
            selectedPhoto = true
            addPictureButton.isHidden = true
            addPhotoButton.setImage(imageView.image, for: .normal)
            
            completionButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            completionButton.tintColor = .systemGreen
            deleteButton.isHidden = false
            
            dateTF.text = convertDateToString(format: "yyyy년 MM월 dd일", date: meal.date)
            viewModel.input.mealDate.onNext(meal.date)
            datePicker.setDate(meal.date, animated: false)
            
            mealtimeTF.text = meal.mealTime.rawValue
            mealnameTF.text = meal.name
            mealpriceTF.text = String(describing: meal.price)
            isDineInSwitch.isOn = mealTypeToBool(meal.mealType)
            
        } else {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        addPhotoButton.setImage(selectedImage, for: .normal)
        self.viewModel.mealService.mealRepository.uploadImage(mealID: self.viewModel.input.mealID, image: selectedImage) { _ in }
        self.viewModel.input.mealURL.onNext(URL(string: "forValidationURL"))
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
            .do(onNext: {
                [unowned self] in
                
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
            .subscribe(onNext: { [unowned self] in
                if self.selectedPhoto {
                    
                    let alertController = UIAlertController(title: "메뉴 사진 업로드", message: "어디에서 메뉴의 사진을 업로드 할까요?", preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                   
                    imagePicker.delegate = self
                    
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        let photoAction = UIAlertAction(title: "사진 라이브러리", style: .default) {
                            action in
                            imagePicker.sourceType = .photoLibrary
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                        alertController.addAction(photoAction)
                    }
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let cameralAction = UIAlertAction(title: "카메라", style: .default) {
                            action in
                            imagePicker.sourceType = .camera
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                        alertController.addAction(cameralAction)
                    }
                    
                    present(alertController, animated: true, completion: nil)
                }
                
            })
            .disposed(by: rx.disposeBag)
        
        addPictureButton.rx.tap
            .do(onNext: { [unowned self] in
                
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
            .subscribe(onNext: { [unowned self] in
                if self.selectedPictrue {
                    let cvc = PictureSelectCollectionViewController.instantiate(storyboardID: "Main")
                    cvc.modalTransitionStyle = .crossDissolve
                    cvc.modalPresentationStyle = .automatic
                    self.present(cvc, animated: true, completion: nil)
                }
                
                
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let alert = UIAlertController(title: "삭제하기", message: "식사를 삭제하시겠어요? 삭제 후에는 복구가 불가능합니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "넹!", style: .default) { action in
                    guard let mealID = self.meal?.id else { return }
                    DispatchQueue.global().async {
                        self.viewModel.mealService.delete(mealID: mealID)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
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
            .debug()
            .drive(completionButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.newMeal
            .subscribe(onNext: { [unowned self] newMeal in
                self.newMeal = newMeal
                print(newMeal.name)
            })
            .disposed(by: rx.disposeBag)
       
    }
    
    @IBAction func completedButtonTapped(_ sender: UIButton) {
        
        guard let newMeal = newMeal else { return }
        
        if self.meal != nil {
            self.viewModel.mealService.update(updateMeal: newMeal) { success in
                if success {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            self.viewModel.mealService.create(meal: newMeal) { success in
                if success {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
