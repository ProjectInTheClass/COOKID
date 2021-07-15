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
    
    let service: ShoppingService
    
    init(service: ShoppingService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let tableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10.0
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    var headerView = PanModalHeaderView()
    
    var rightBtn = PanModalHeaderView().rightBtn
    
    lazy var dateTextField = UITextField().then{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yyyy년 MM월 dd일"
        $0.placeholder = dateformatter.string(from: Date())
    }
    lazy var priceTextField = UITextField().then{
        $0.keyboardType = .numberPad
        $0.placeholder = "금액을 입력하세요."
    }
    var datePicker = UIDatePicker()
    
    
    let tapGesture = UITapGestureRecognizer()
    
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
        headerView.rightBtn.addTarget(self, action: #selector(createFunc) , for: .touchUpInside)
    }
    
    
    @objc func createFunc() {
        print("btn tapped")
        guard let price = self.priceTextField.text, price.count > 0, let dateStr = self.dateTextField.text, dateStr.count > 0 else {
            self.alert(message: "입력란을 다 채워주세요!")
            return
        }

        let date = datePicker.date
            
        let aShoppingItem = GroceryShopping(id: "wkwkfe", date: date, totalPrice: Int(price)!)
        
        service.create(shopping: aShoppingItem)
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Constraints
extension InputDataShoppingViewController {
    func setUpConstraints() {
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addGestureRecognizer(tapGesture)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.priceTextField.delegate = self
        self.dateTextField.delegate = self
        self.tapGesture.delegate = self
        
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
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.datePicker.timeZone = .autoupdatingCurrent
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.setDate(Date(), animated: true)
        self.datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
            self.datePicker.sizeToFit()
        }
        
        self.dateTextField.inputView = self.datePicker
        
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
            dateformatter.dateFormat = "yyyy년 MM월 dd일"
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
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
                
        present(alert, animated: true, completion: nil)
    }
}

extension InputDataShoppingViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {        
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }
        self.dismiss(animated: true, completion: nil)
        return true
    }
}
