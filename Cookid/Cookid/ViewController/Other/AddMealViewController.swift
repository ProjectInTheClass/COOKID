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
    
    
    // test
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var mealtimeTF: UITextField!
    @IBOutlet weak var mealnameTF: UITextField!
    @IBOutlet weak var mealpriceTF: UITextField!
    
    // reactive
    var selectedPhoto: Bool = false
    var selectedPictrue: Bool = false
    
    var viewModel: AddMealViewModel!
    
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
    }
    
    private func initialSetting() {
        guard let meal = meal else { return }
        
        dateTF.text = convertDateToString(format: "MM월 dd일", date: meal.date)
        mealtimeTF.text = meal.mealTime.rawValue
        mealnameTF.text = meal.name
        mealpriceTF.text = intToString(meal.price)
        isDineInSwitch.isOn = mealTypeToBool(meal.mealType)
    }
    
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
