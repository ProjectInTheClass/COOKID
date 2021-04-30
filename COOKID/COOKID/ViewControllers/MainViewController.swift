//
//  MainViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/20.
//

import UIKit

var foods: [FoodInfo] = [FoodInfo(image: UIImage(named: "pizza")!, when: "아침", name: "피자"),
                         FoodInfo(image: UIImage(named: "takoyaki")!, when: "점심", name: "타코야키"),
                         FoodInfo(image: UIImage(named: "poke")!, when: "저녁", name: "삼겸살"),]


class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //데이터가 몇 개인가?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return foods.count
        }
        else {
            return 1
        }
    }
    
    
    //데이터가 무엇인가?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! EatingDataCollectionViewCell
            
            addCell.layer.cornerRadius = 5.0
            addCell.layer.backgroundColor = UIColor.green.cgColor

            return addCell
        }
        
        let foodInfo = foods[indexPath.row]
        
        let eatingDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EatingDataCell", for: indexPath) as! EatingDataCollectionViewCell
        
        eatingDataCell.layer.cornerRadius = 5.0
        eatingDataCell.layer.backgroundColor = UIColor.gray.cgColor
        
        /// 셀에 정보 보여주기.
        eatingDataCell.foodImage.image = foodInfo.image
        eatingDataCell.eatingTimeLabel.text = foodInfo.when
        eatingDataCell.foodNameLabel.text = foodInfo.name
        
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
