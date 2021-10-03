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
import SnapKit
import Then

class MyPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - Properties
    
    var viewModel: MyPageViewModel!
    var coordinator : MyPageCoordinator?
    
    // MARK: - View LifeCycle and Fuctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "내 정보 ⚙️"
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
    
    // MARK: - BindViewMdoel
    func bindViewModel() {
        
    }
    
}
