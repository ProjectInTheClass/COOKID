//
//  MyPageDetailViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/07.
//

import UIKit
import PagingKit

class MyPageDetailViewController: UIViewController, ViewModelBindable {
    
    var viewModel: MyPageViewModel!
    var coordinator: HomeCoordinator?
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource: [(String, UIViewController)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myMealsVC = MyMealsViewController()
        myMealsVC.bind(viewModel: viewModel)
        myMealsVC.coordinator = coordinator
        var myRecipesVC = MyRecipesViewController()
        myRecipesVC.bind(viewModel: viewModel)
        var myHeartsVC = MyPostsViewController()
        myHeartsVC.bind(viewModel: viewModel)
        
        dataSource = [(menuTitle: "나의 식사", vc: myMealsVC), (menuTitle: "나의 레시피", vc: myRecipesVC), (menuTitle: "나의 글", vc: myHeartsVC)]
        
        menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.menuCell)
        menuViewController.registerFocusView(view: UnderlineFocusView())
        
        menuViewController.cellAlignment = .center
        
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
    
    func bindViewModel() {
        
    }
}

extension MyPageDetailViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return view.frame.width / 3
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        guard let cell = viewController.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.menuCell, for: index) as? TitleLabelMenuViewCell else { return PagingMenuViewCell() }
        cell.titleLabel.text = dataSource?[index].0
        return cell
    }
}

extension MyPageDetailViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource?[index].1 ?? UIViewController()
    }
}

extension MyPageDetailViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension MyPageDetailViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
