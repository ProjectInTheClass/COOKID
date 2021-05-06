//
//  MainViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/20.
//

import UIKit

var foods: [Food] = [Food(foodImage: UIImage(named: "pizza")!, mealType: .breakfast, foodName: "피자", price: 30000, category: .fruit, date: Date()),
                         Food(foodImage: UIImage(named: "poke")!, mealType: .lunch, foodName: "삼겹살", price: 28000, category: .stirFriedFood, date: Date()),
                         Food(foodImage: UIImage(named: "takoyaki")!, mealType: .dinner, foodName: "타코야키", price: 5000, category: .riceCake, date: Date())
]

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //데이터가 몇 개인가?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    
    //데이터가 무엇인가?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let foodInfo = foods[indexPath.row]
        
        let eatingDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EatingDataCell", for: indexPath) as! EatingDataCollectionViewCell
        
        eatingDataCell.layer.cornerRadius = 5.0
        eatingDataCell.layer.backgroundColor = UIColor.gray.cgColor
        
        /// 셀에 정보 보여주기.
        eatingDataCell.foodImage.image = foodInfo.foodImage
        eatingDataCell.eatingTimeLabel.text = foodInfo.mealType.rawValue
        eatingDataCell.foodNameLabel.text = foodInfo.foodName
    
        return eatingDataCell
    }
    
    @IBOutlet var collectionMain: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionMain.delegate = self
        collectionMain.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "MoveToEatingDataView", sender: self)
//    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MoveToEatingDataView" {
            print("디테일 조회")
            
            let vcDest = segue.destination as! EatingDataViewController
            
            vcDest.foodSelected = foods[collectionMain.indexPathsForSelectedItems!.first!.row]
            
        }
        else if segue.identifier == "MoveToEatingAddView" {
            print("항목 추가")
            
            let vcDest = segue.destination as! EatingDataViewController
            
            vcDest.closureAfterSaved = {
                self.collectionMain.reloadData()
            }

        }
    }


}
