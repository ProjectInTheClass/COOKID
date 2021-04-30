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
    
    @IBOutlet var buttons : [UIButton]!
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
            naviBarTop.topItem?.title = "신규 추가"
            naviBarTop.topItem?.rightBarButtonItem?.title = "추가"
        }
        else { // 디테일 조회?
            naviBarTop.topItem?.title = "참 맛있었다"
            naviBarTop.topItem?.rightBarButtonItem?.title = "수정"
        }
        
        foodNameTextField.text = foodSelected?.name
        foodImageView.image = foodSelected?.image
        
        for buttons in buttons {
            buttons.layer.borderWidth = 0.5
            buttons.layer.borderColor = UIColor.systemGray.cgColor
            buttons.layer.cornerRadius = 3
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        foods.append(FoodInfo(image: UIImage(named: "pizza")!, when: "야식", name: "핏자"))
        

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
