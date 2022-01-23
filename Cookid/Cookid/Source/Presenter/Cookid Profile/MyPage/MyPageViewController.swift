//
//  MyPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SystemConfiguration
import PagingKit

class MyPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - Properties
    
    var viewModel: MyPageViewModel!
    var coordinator : MyPageCoordinator?
    
    // MARK: - View LifeCycle and Fuctions
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var dataSource: [(String, UIViewController)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource?.forEach({ value in
            switch value.1 {
            case is MyBookmarkViewController:
                if let vc = value.1 as? MyBookmarkViewController {
                    vc.coordinator = coordinator
                }
            case is MyMealsViewController:
                if let vc = value.1 as? MyMealsViewController {
                    vc.coordinator = coordinator
                }
            case is MyPostsViewController:
                if let vc = value.1 as? MyPostsViewController {
                    vc.coordinator = coordinator
                }
            case is MyRecipeViewController:
                if let vc = value.1 as? MyRecipeViewController {
                    vc.coordinator = coordinator
                }
            default:
                break
            }
        })
    }
    
    private func setViewControllers() {
        var myMealsVC = MyMealsViewController()
        myMealsVC.bind(viewModel: viewModel)
        myMealsVC.coordinator = coordinator
        
        let myBookmarkVC = MyBookmarkViewController()
        myBookmarkVC.reactor = MyBookmarkReactor(userService: viewModel.userService, postService: viewModel.postService, shoppingService: viewModel.shoppingService, mealService: viewModel.mealService)
        myBookmarkVC.coordinator = coordinator
        
        let myPostVC = MyPostsViewController()
        myPostVC.coordinator = coordinator
        myPostVC.reactor = MyPostReactor(userService: viewModel.userService, postService: viewModel.postService)
        
        let myRecipeVC = MyRecipeViewController()
        myRecipeVC.coordinator = coordinator
        myRecipeVC.reactor = MyRecipeReactor(userService: viewModel.userService, postService: viewModel.postService)
        
        dataSource = [(menuTitle: "식사들", vc: myMealsVC), (menuTitle: "내 글", vc: myPostVC), (menuTitle: "북마크", vc: myBookmarkVC), (menuTitle: "레시피", vc: myRecipeVC)]

        menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.menuCell)
        menuViewController.registerFocusView(view: UnderlineFocusView())
        menuViewController.cellAlignment = .center
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "마이페이지"
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
        
        if segue.identifier == "headerSegue" {
            guard var vc = segue.destination as? MyPageHeaderViewController else { return }
            vc.coordinator = coordinator
            vc.bind(viewModel: viewModel)
        }
    }

    // MARK: - BindViewMdoel
    func bindViewModel() {
        
    }
    
}

extension MyPageViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return view.frame.width / 4 - 10
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        guard let cell = viewController.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.menuCell, for: index) as? TitleLabelMenuViewCell else { return PagingMenuViewCell() }
        cell.titleLabel.text = dataSource?[index].0
        cell.focusColor = DefaultStyle.Color.labelTint
        cell.normalColor = DefaultStyle.Color.labelTint
        return cell
    }
}

extension MyPageViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource?[index].1 ?? UIViewController()
    }
}

extension MyPageViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension MyPageViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
