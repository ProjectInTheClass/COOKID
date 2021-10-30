//
//  BaseViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }
    
  var disposeBag = DisposeBag()

  private(set) var didSetupConstraints = false

  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateViewConstraints()
  }

  func setupConstraints() { }

}
