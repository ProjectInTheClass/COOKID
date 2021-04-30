//
//  ViewController.swift
//  MyDatePicker
//
//  Created by 임현지 on 2021/04/19.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? itemCell else { return UICollectionViewCell() }
        return cell
    }
    
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePickerView()
        
//        datePicker.datePickerStyle
//        let childVC = ChildVC(nibName: nil, bundle: nil)
//        add(childVC: childVC, to: self.childView)
        
    }

    @IBAction func datePickerTapped(_ sender: Any) {
        //datePicker.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
    }
    
    func configureDatePickerView() {
        datePickerView.layer.cornerRadius = 15
        datePickerView.layer.shadowColor = UIColor.systemGray4.cgColor
        datePickerView.layer.shadowOpacity = 0.6
        datePickerView.layer.shadowRadius = 6
    }
    
//    func add(childVC: UIViewController, to containerView: UIView) {
//        addChild(childVC)
//        containerView.addSubview(childVC.view)
//        childVC.view.frame = containerView.bounds
//        childVC.didMove(toParent: self)
//    }
    
    class itemCell : UICollectionViewCell {
        
        @IBOutlet weak var dateLabel: UILabel!
        @IBOutlet weak var descriptionLabel: UILabel!
        
        func update() {
            
        }
    }
}


