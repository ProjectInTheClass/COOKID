//
//  InputDataShoppingViewController.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/12.
//

import UIKit
import SnapKit
import Then

class InputDataShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
            
    let tableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    var headerView = PanModalHeaderView()
    let shoppingService = ShoppingService()
    
    var rightBtn = PanModalHeaderView().rightBtn
    
    lazy var dateTextField = UITextField().then{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        dateformatter.dateFormat = "yyyy년 MM월 dd일"
        $0.placeholder = dateformatter.string(from: Date())
    }
    lazy var priceTextField = UITextField().then{
        $0.keyboardType = .numberPad
        $0.placeholder = "금액을 입력하세요."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setInputViewDatePicker(target: self, selector: #selector(doneTapped))
    }
    
}

//MARK: - Constraints
extension InputDataShoppingViewController {
    func setUpConstraints() {
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.priceTextField.delegate = self
        self.dateTextField.delegate = self
        
        tableView.separatorStyle = .none
        tableView.register(InputDataTableViewCell.self, forCellReuseIdentifier: InputDataTableViewCell.identifier)
        
        tableView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(215)
        }
    }
    
    //MARK: - DatePicker
    func setInputViewDatePicker(target : Any, selector : Selector) {
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

//MARK: - TableView
extension InputDataShoppingViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InputDataTableViewCell.identifier, for: indexPath) as? InputDataTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 1:
            cell.contentView.addSubview(dateTextField)
            dateTextField.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(cell.contentView.snp.leading).offset(16)
                $0.trailing.equalTo(cell.contentView.snp.trailing)
            }
        case 2:
            cell.contentView.addSubview(priceTextField)
            priceTextField.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(cell.contentView.snp.leading).offset(16)
                $0.trailing.equalTo(cell.contentView.snp.trailing)
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "날짜"
        case 2:
            return "가격"
        default:
            return nil
        }
    }
}

//MARK: - saveButtonTapped
extension InputDataShoppingViewController {
    func createNewShopping () -> Void {
        guard let dateStr = dateTextField.text, let priceStr = priceTextField.text, let price = Int(priceStr) else { return }
        let date = stringToDate(date: dateStr)
        let aShoppingItem = GroceryShopping(id: "", date: date, totalPrice: price)
        shoppingService.create(shopping: aShoppingItem)
    }
}

extension InputDataShoppingViewController {
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
                
        present(alert, animated: true, completion: nil)
    }
}
