//
//  MyPageDetailViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/07.
//

import UIKit

protocol MenuBarDelegate: AnyObject {
    func menuTapped(indexPath: IndexPath)
}
 
protocol ContentsViewControllerDelegate: AnyObject {
    func scrolledContentsViewController(currentIndex: Int)
}

class MyPageDetailViewController: UIViewController {
    
    private lazy var menuBar: MenuBarViewController = {
        let view = MenuBarViewController(foodMenu: menu)
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    private lazy var containerView: ContainerViewController = {
        let view = ContainerViewController(foodMenu: menu)
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension MyPageDetailViewController: MenuBarDelegate {
    func menuTapped(indexPath: IndexPath) {
        if indexPath.row == self.containerView.currentIndex {
            return
        }
        let direction: UIPageViewController.NavigationDirection = indexPath.row > (self.containerView.currentIndex ?? 0) ? .forward : .reverse
        let nextViewController = getNextVC(indexPath)
        self.containerView.setViewControllers([nextViewController], direction: direction, animated: false, completion: nil)
        self.containerView.currentIndex = indexPath.row
    }
}

extension MyPageDetailViewController: ContentsViewControllerDelegate {
    func scrolledContentsViewController(currentIndex: Int) {
        let indexPath: IndexPath = IndexPath(row: currentIndex, section: 0)
        _ = getNextVC(indexPath)
        self.menuBar.collectionView(self.menuBar.menu, didSelectItemAt: indexPath)
    }
}
