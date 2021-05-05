//
//  CostViewController.swift
//  COOKID
//
//  Created by 임현지 on 2021/05/05.
//

import UIKit

class CostViewController: UIViewController {
    
    @IBOutlet weak var costCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costCollectionView.delegate = self
        costCollectionView.dataSource = self
       
    }
}

extension CostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DateViewController.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostCell", for: indexPath) as! CostCollectionViewCell
        let dateVC = DateViewController()
        let selectedDate = dateVC.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dates = dateFormatter.string(from: selectedDate)
        
        cell.dateLabel.text = dates
        
        return cell
    }
}
