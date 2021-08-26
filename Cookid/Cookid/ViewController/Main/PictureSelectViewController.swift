//
//  PictureSelectViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/26.
//

import UIKit
import PanModal
import SnapKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx

class PictureSelectViewController: UIViewController, ViewModelBindable {
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(PictureSelectCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.pictureSelectCell)
        $0.backgroundColor = .systemBackground
        $0.contentInset = UIEdgeInsets(top: 40, left: 30, bottom: 30, right: 30)
    }
    
    // Properties
    
    var viewModel: AddMealViewModel!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view)
        }
        
    }
    
    // MARK: - Functions
    
    // MARK: - Bind ViewModel
    func bindViewModel() {
        
        viewModel.input.menus
            .debug()
            .bind(to: collectionView.rx.items(cellIdentifier: CELLIDENTIFIER.pictureSelectCell, cellType: PictureSelectCollectionViewCell.self)) { _, item, cell in
                cell.updateUI(menu: item)
            }
            .disposed(by: rx.disposeBag)
            
        collectionView.rx.modelSelected(Menu.self)
            .bind(onNext: { [unowned self] menu in
                guard let menuImage = menu.image else { print("error")
                    return }
                self.viewModel.input.mealImage.accept(menuImage)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self)
    }

}

extension PictureSelectViewController: UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, PanModalPresentable {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3 - 50, height: view.frame.width/3 - 50)
    }
    
    var panScrollable: UIScrollView? {
        return collectionView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.height * 2/3)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
    
}
