//
//  InputDataShoppingViewController.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/12.
//

import UIKit
import PanModal
import SnapKit
import Then

class InputDataShoppingViewController: UIViewController {

    lazy var dateTextField = UITextField()
    lazy var priceTextField = UITextField().then{
        $0.placeholder = "금액을 입력하세요."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpConstraints()
        setInputViewDataPicker(target: self, selector: #selector(doneTapped))

        // Do any additional setup after loading the view.
    }
    
}

extension InputDataShoppingViewController: PanModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(200)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
}

extension InputDataShoppingViewController {
    func setUpConstraints() {
        self.view.addSubview(dateTextField)
        
        self.dateTextField.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        
        self.priceTextField.snp.makeConstraints{
            $0.top.equalTo(dateTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        
        
    }
    
    
    func setInputViewDataPicker(target : Any, selector : Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.setDate(Date(), animated: true)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        
        self.dateTextField.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(cancelTapped))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, done], animated: false)
        self.dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func cancelTapped() {
        self.resignFirstResponder()
    }
    
    @objc func doneTapped() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            dateformatter.timeStyle = .none
            self.dateTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.dateTextField.resignFirstResponder()
    }
    
}
