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
    var currentPrice : String?
    var currentDate : String?
    
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
        tableView.layer.cornerRadius = 8.0
        tableView.allowsSelection = false
        tableView.sizeToFit()
        return tableView
    }()
    
    var headerView = PanModalHeaderView()
    
    var saveBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        return btn
    }()
    
    var updateBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("수정", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        return btn
    }()
    
    let dateTextField : UITextField = {
        let dateTF = UITextField()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        dateformatter.locale = Locale(identifier: "ko_KR")
        dateformatter.dateFormat = "yyyy년 MM월 dd일"
        dateTF.placeholder = dateformatter.string(from: Date())
        dateTF.font = .systemFont(ofSize: 18, weight: .ultraLight)
        dateTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return dateTF
    }()
    
    let priceTextField : UITextField = {
        let priceTF = UITextField()
        priceTF.keyboardType = .numberPad
        priceTF.font = .systemFont(ofSize: 18, weight: .ultraLight)
        priceTF.placeholder = "금액을 입력하세요."
        priceTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return priceTF
    }()
    
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
        saveBtn.addTarget(self, action: #selector(createFunc) , for: .touchUpInside)
        updateBtn.addTarget(self, action: #selector(self.updateFunc) , for: .touchUpInside)
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
            $0.height.equalTo(235)
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
        let view = UIView()
        view.backgroundColor = .clear
        let headerLabel = UILabel().then{
            $0.font = .systemFont(ofSize: 16, weight: .thin)
            $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
        }
        switch section {
        case 0:
            headerView.addSubview(saveBtn)
            headerView.addSubview(updateBtn)
            saveBtn.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.width.equalTo(40)
            }
            updateBtn.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.width.equalTo(40)
            }
            return headerView
        case 1:
            headerLabel.text = "날짜"
            return view
        case 2:
            headerLabel.text = "금액"
            return view
        default:
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
                $0.height.equalToSuperview()
            }
        case 2:
            cell.contentView.addSubview(priceTextField)
            priceTextField.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(cell.contentView.snp.leading).offset(16)
                $0.trailing.equalTo(cell.contentView.snp.trailing)
                $0.height.equalToSuperview()
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
}

//MARK: - save or updateButton

extension InputDataShoppingViewController {
    
    func selectBtn (btnState : btnState) {
        switch btnState {
        case .saveBtnOn :
            updateBtn.isHidden = true
            saveBtn.isHidden = false
        case .updateBtnOn :
            updateBtn.isHidden = false
            saveBtn.isHidden = true
        }
    }

    enum btnState {
        case saveBtnOn
        case updateBtnOn
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
    
    @objc func updateFunc() {
        print("update btn tapped")
        if self.currentPrice == self.priceTextField.text && self.currentDate == self.dateTextField.text {
            print("just dismiss")
            self.dismiss(animated: true, completion: nil)
        } else {
            guard let editedPrice = self.priceTextField.text, editedPrice.count > 0, let editedDateStr = self.dateTextField.text, editedDateStr.count > 0 else {
                self.alert(message: "입력란을 다 채워주세요!")
                return
            }
            alert2(message: "편집 내용을 저장하시겠습니까?")
        }
    }
    
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
                
        present(alert, animated: true, completion: nil)
    }
    
    func alert2(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) {_ in
            let date = self.datePicker.date
            let price = self.priceTextField.text!
            let aShoppingItem = GroceryShopping(id: "wkwkfe", date: date, totalPrice: Int(price)!)
            self.service.update(updateShopping: aShoppingItem)
            print("update 함수 호출")
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
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
