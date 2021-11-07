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

class MyPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - Properties
    
    var viewModel: MyPageViewModel!
    var coordinator : MyPageCoordinator?
   
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - View LifeCycle and Fuctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "마이페이지"
        self.headerView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard var vc = segue.destination as? MyPageDetailViewController else { return }
            vc.coordinator = coordinator
            vc.bind(viewModel: viewModel)
        }
        
        if segue.identifier == "headerSegue" {
            guard var vc = segue.destination as? MyPageHeaderViewController else { return }
            vc.coordinator = coordinator
            vc.bind(viewModel: viewModel)
        }
    }
    
    @IBAction func userInfoButton(_ sender: Any) {
        self.headerView.isHidden.toggle()
    }

    // MARK: - BindViewMdoel
    func bindViewModel() {
        
    }
    
}
