//
//  EatingDataViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/28.
//

import UIKit

class EatingDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var foodSelected: FoodInfo?
    /// 결과 업데이트 되었음을 알려주자.
    var closureAfterSaved: (() -> Void)?
    
    var restoreFrameValue : CGFloat = 0.0
    var category = ["밥류", "찌개류", "볶음류", "빵, 과자류", "탕류", "튀김류", "우유, 유제품"]

    
    @IBOutlet weak var naviBarTop: UINavigationBar!
    
    @IBOutlet var breakfastButton: UIButton!
    @IBOutlet var brunchButton: UIButton!
    @IBOutlet var lunchButton: UIButton!
    @IBOutlet var lunDinnerButton: UIButton!
    @IBOutlet var DinnerButton: UIButton!
    @IBOutlet var snackButton: UIButton!
    
    @IBOutlet var foodNameTextField: UITextField!
    @IBOutlet var estimatedPriceTextField: UITextField!
    @IBOutlet var categoryLabel: UITextField!
    @IBOutlet var foodImageView: UIImageView! {
        didSet {
            foodImageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet var eatOutSwitch: UISwitch!
    
    //피커뷰
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryLabel.text = category[row]
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryLabel.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(ButtonAction))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        categoryLabel.inputAccessoryView = toolbar
    }
    
    @objc func ButtonAction() {
        categoryLabel.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if foodSelected == nil { // 신규 추가
            naviBarTop.topItem?.title = "식사 기록하기"
            naviBarTop.topItem?.rightBarButtonItem?.title = "추가"
        }
        else { // 디테일 조회?
            naviBarTop.topItem?.title = "식사 수정하기"
            naviBarTop.topItem?.rightBarButtonItem?.title = "수정"
        }
        
        foodNameTextField.text = foodSelected?.foodName
        foodImageView.image = foodSelected?.foodImage
        
        let buttons : [UIButton] = [breakfastButton, brunchButton, lunchButton, lunDinnerButton, DinnerButton, snackButton]
     
        
        for buttons in buttons {
            buttons.layer.borderWidth = 0.5
            buttons.layer.borderColor = UIColor.systemGray.cgColor
            buttons.layer.cornerRadius = 3

        }
        
        let fields = [foodNameTextField, estimatedPriceTextField, categoryLabel]
        
        for i in 0...2 {
            fields[i]?.layer.borderWidth = 0.5
            fields[i]?.layer.borderColor = UIColor.systemGray.cgColor
            fields[i]!.layer.cornerRadius = 3
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFoodImageView(_:)))
        foodImageView.addGestureRecognizer(tapGestureRecognizer)
        
        createPickerView()
        dismissPickerView()
        
        restoreFrameValue = self.view.frame.origin.y
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @IBAction func mealTypeButtonTapped(_ sender: UIButton){
        switch sender {
        case breakfastButton:
            foodSelected?.mealType = .breakfast
            print("아침 버튼, \(String(describing: foodSelected?.mealType))")
        case brunchButton :
            foodSelected?.mealType = .brunch
            print("아점 버튼, \(String(describing: foodSelected?.mealType))")
        case lunchButton :
            foodSelected?.mealType = .lunch
            print("점심 버튼, \(String(describing: foodSelected?.mealType))")
        case lunDinnerButton :
            foodSelected?.mealType = .lundinner
            print("점저 버튼, \(String(describing: foodSelected?.mealType))")
        case DinnerButton :
            foodSelected?.mealType = .dinner
            print("저녁 버튼, \(String(describing: foodSelected?.mealType))")
        case snackButton :
            foodSelected?.mealType = .snack
            print("간식 버튼, \(String(describing: foodSelected?.mealType))")
        default:
            foodSelected?.mealType = .init(rawValue: " ")!
        }
    }


    @IBAction func saveButtonTapped(_ sender: Any) {
//        foodSelected = FoodInfo(foodImage: UIImage(named: ""), mealType: , eatOut: eatOutSwitch.isOn, foodName: foodNameTextField.text, price: estimatedPriceTextField.text, category: .diary)

//        closureAfterSaved?()
        
        dismiss(animated: true) {
            if let c = self.closureAfterSaved { c() }
        }
    }

    @IBAction func didTapFoodImageView(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            
            foodImageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}

extension EatingDataViewController {
    
    @objc func keyboardWillAppear(noti : NSNotification) {
        if let keyboardFrame : NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
        print("keyboard Will Appear Execute")
    }
    
    @objc func keyboardWillDisappear(noti : NSNotification) {
        if self.view.frame.origin.y != restoreFrameValue {
            if let keyboardFrame : NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
            print("keyboard Will Disappear Execute")
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = restoreFrameValue
        print("touchesBegan Execute")
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn Execute")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing Execute")
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
}


