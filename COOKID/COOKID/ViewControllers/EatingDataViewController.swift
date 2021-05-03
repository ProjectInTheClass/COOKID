//
//  EatingDataViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/28.
//

import UIKit

class EatingDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var naviBarTop: UINavigationBar!
    
    var foodSelected: FoodInfo?
    /// 결과 업데이트 되었음을 알려주자.
    var closureAfterSaved: (() -> Void)?
    
    @IBOutlet var breakfastButton: UIButton!
    @IBOutlet var brunchButton: UIButton!
    @IBOutlet var lunchButton: UIButton!
    @IBOutlet var lunDinnetButton: UIButton!
    @IBOutlet var DinnerButton: UIButton!
    @IBOutlet var snackButton: UIButton!
    
    @IBOutlet var foodNameTextField: UITextField!
    @IBOutlet var estimatedPriceTextField: UITextField!
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var foodImageView: UIImageView! {
        didSet {
            foodImageView.isUserInteractionEnabled = true
        }
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
        
        let buttons : [UIButton] = [breakfastButton, brunchButton, lunchButton, lunDinnetButton, DinnerButton, snackButton]
     
        
        for buttons in buttons {
            buttons.layer.borderWidth = 0.5
            buttons.layer.borderColor = UIColor.systemGray.cgColor
            buttons.layer.cornerRadius = 3
            buttons.setBackgoundColor(.white, for: .normal)
            buttons.setBackgoundColor(.systemBlue, for: .selected)
        }
        
        let fields = [foodNameTextField, estimatedPriceTextField, categoryButton]
        
        for i in 0...2 {
            fields[i]?.layer.borderWidth = 0.5
            fields[i]?.layer.borderColor = UIColor.systemGray.cgColor
            fields[i]!.layer.cornerRadius = 3
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFoodImageView(_:)))
        foodImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    

//
//    @IBAction func mealTypeButtonTapped(_ sender: UIButton){
//        switch sender {
//        case breakfastButton:
//
//        default:
//            <#code#>
//        }
//    }
//
//    func buttonSelected (sender : UIButton) -> Bool {
//
//    }
//
    @IBAction func saveButtonTapped(_ sender: Any) {

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


extension UIButton {
    func setBackgoundColor(_ color : UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

