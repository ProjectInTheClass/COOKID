//
//  MenuBarViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/07.
//

import UIKit

private let reuseIdentifier = "Cell"

class MenuBarViewController: UICollectionViewController {
    
public weak var menuDelegate: MenuBarDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousCell = collectionView.cellForItem(at: self.selectedIndexPath) as? MenuCell {
            previousCell.isSelected = false
        }
     
        self.selectedIndexPath = indexPath
        guard let currentCell: MenuCell = collectionView.cellForItem(at: self.selectedIndexPath) as? MenuCell else { return }
     
        currentCell.isSelected = true
     
        collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: true)
        self.menuDelegate?.menuTapped(indexPath: self.selectedIndexPath)
    }
    
}
