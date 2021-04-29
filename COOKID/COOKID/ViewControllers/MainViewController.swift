//
//  MainViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/20.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var numberOfCell : Int = 5
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //데이터가 몇 개인가?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    
    //데이터가 무엇인가?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let eatingDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EatingDataCell", for: indexPath) as! EatingDataCollectionViewCell
        
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! EatingDataCollectionViewCell
        
        eatingDataCell.layer.cornerRadius = 5.0
        eatingDataCell.layer.backgroundColor = UIColor.gray.cgColor
        addCell.layer.cornerRadius = 5.0
        addCell.layer.backgroundColor = UIColor.green.cgColor
        
        return eatingDataCell
    }
    
    @IBOutlet var collectionMain: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionMain.delegate = self
        collectionMain.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MoveToEatingDataView", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
