//
//  BaseViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
        self.view.backgroundColor = .systemBackground
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup), name: NSNotification.Name("statusCode"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("statusCode"), object: nil)
    }
    
    @objc func showErrorPopup(_ notification: Notification) {
        let statusCode = notification.object as! Int
        if !(200..<300).contains(statusCode) {
            print(String(describing: statusCode))
        }
    }
    
    // overrride
    func setupConstraints() { }
    
}
