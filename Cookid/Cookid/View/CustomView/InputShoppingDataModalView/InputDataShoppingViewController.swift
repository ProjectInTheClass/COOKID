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

class InputDataShoppingViewController: UITableViewController, PanModalPresentable, UITextFieldDelegate  {
    
    var completionHandler : (() -> Void)?
    
    let shoppingService = ShoppingService()
    
    lazy var dateTextField = UITextField().then{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        $0.placeholder = dateformatter.string(from: Date())
    }
    lazy var priceTextField = UITextField().then{
        $0.placeholder = "금액을 입력하세요."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceTextField.resignFirstResponder()
        return true
    }
    
    //MARK: - PanModalPresentable SetUp
    
    let contentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    
    var hasLoaded : Bool = false
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    let headerView = PanModalHeaderView()
    
    var isShortFormEnabled = true
    
    var shortFormHeight: PanModalHeight {
        if hasLoaded {
            return .contentHeight(400.0)
        }
        return .contentHeight(200.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
    
    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerView.frame.contains(location)
    }
    
    var scrollIndicatorInsets: UIEdgeInsets {
        let bottomOffset = presentingViewController?.view.safeAreaInsets.bottom ?? 0
        return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
        else { return }
        
        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
    
    //MARK: - keyboardNotification
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasLoaded = false
        view.backgroundColor = .white
        setUpConstraints()
        setInputViewDatePicker(target: self, selector: #selector(doneTapped))
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                var inset = strongSelf.presentingViewController!.view.safeAreaInsets
                
                inset.bottom = height
                strongSelf.tableView.contentInset = inset
                                
                inset = strongSelf.tableView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.tableView.scrollIndicatorInsets = inset
                
                strongSelf.hasLoaded = true
                strongSelf.panModalSetNeedsLayoutUpdate()
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.presentingViewController!.view.safeAreaInsets
            inset.bottom = 0
            strongSelf.tableView.contentInset = inset
            
            inset = strongSelf.tableView.verticalScrollIndicatorInsets
            inset.bottom = 0
            strongSelf.tableView.scrollIndicatorInsets = inset
            
            strongSelf.hasLoaded = false
            strongSelf.panModalSetNeedsLayoutUpdate()
        })
    }
}

//MARK: - Constraints
extension InputDataShoppingViewController {
    func setUpConstraints() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.priceTextField.delegate = self
        self.dateTextField.delegate = self
        
        tableView.separatorStyle = .none
        tableView.register(InputDataTableViewCell.self, forCellReuseIdentifier: InputDataTableViewCell.identifier)
        
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InputDataTableViewCell.identifier, for: indexPath) as? InputDataTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(dateTextField)
            dateTextField.snp.makeConstraints{
                $0.top.equalTo(cell.contentView.snp.top).offset(8)
                $0.bottom.equalTo(cell.contentView.snp.bottom).offset(8)
                $0.leading.equalTo(cell.contentView.snp.leading).offset(16)
                $0.trailing.equalTo(cell.contentView.snp.trailing).offset(16)
            }
        case 1:
            cell.contentView.addSubview(priceTextField)
            priceTextField.snp.makeConstraints{
                $0.top.equalTo(cell.contentView.snp.top).offset(8)
                $0.bottom.equalTo(cell.contentView.snp.bottom).offset(8)
                $0.leading.equalTo(cell.contentView.snp.leading).offset(16)
                $0.trailing.equalTo(cell.contentView.snp.trailing).offset(16)
            }
        default:
            return cell
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
