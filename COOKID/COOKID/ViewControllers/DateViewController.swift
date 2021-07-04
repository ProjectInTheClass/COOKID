//
//  EatingDateViewController.swift
//  COOKID
//
//  Created by 임현지 on 2021/04/30.

import UIKit

class DateViewController: UIViewController {
    
    static var dates = String()
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var CostCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CostCollectionView.dataSource = self
        CostCollectionView.delegate = self
    }
    
    @IBAction func datePickerTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let costVC = CostCollectionView
        costVC?.reloadData()
    }
}



extension DateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostCell", for: indexPath) as! CostCollectionViewCell
        
        let dates = datePicker.date
        return cell
    }
    
}
