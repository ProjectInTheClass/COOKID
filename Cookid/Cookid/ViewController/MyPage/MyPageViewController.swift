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

class MyPageViewController: UIViewController, ViewModelBindable, StoryboardBased, UIScrollViewDelegate {
    
    // MARK: - UIComponents
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInfo: MyPageHeaderView!
    
    // MARK: - Properties
    
    var viewModel: MyPageViewModel!
    var coordinator : HomeCoordinator?
    
    // MARK: - View LifeCycle and Fuctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        scrollView.delegate = self
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "내 정보 ⚙️"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
    }
    
    @objc func settingButtonTapped() {
        coordinator?.navigateUserInfoVC(viewModel: viewModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard var vc = segue.destination as? MyPageDetailViewController else { return }
            vc.coordinator = coordinator
            vc.bind(viewModel: viewModel)
            
        }
    }
    
    // MARK: - BindViewMdoel
    func bindViewModel() {
        viewModel.output.userInfo
            .bind { [unowned self] (user) in
                self.userInfo.updateUI(user: user)
            }
            .disposed(by: rx.disposeBag)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let offSet = scrollView.contentOffset.y
//        
//        if offSet < 150 {
//            let alpha = 1 - (offSet / 150)
//            
//            headerView.transform = .init(translationX: 0, y: min(0,-offSet))
//            scrollViewTopLayout.constant = min(0,-offSet)
//            headerView.layer.shadowOpacity = Float((offSet / 150) - 0.5)
//        }
//    }
    
}
