//
//  AddPostImageCollectionViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class AddPostImageCollectionViewController: UICollectionViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(AddPostImageCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.postImageCell)
        collectionView.register(AddPostCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
    }
    
    func bind(reactor: AddPostReactor) {
        reactor.state.map { $0.images }
        .withUnretained(self)
        .bind(onNext: { owner, _ in
            owner.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }
}

// collectionView에서 FooterView를 사용하기 위해서는 Datasource에 직접 접근, 구현해야 함
extension AddPostImageCollectionViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return  reactor.currentState.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.postImageCell, for: indexPath) as? AddPostImageCollectionViewCell,
              let reactor = reactor else { return UICollectionViewCell() }
        // viewModel로 따로 wrapping하지 않음.
        cell.updateUI(image: reactor.currentState.images[indexPath.item])
        // rx로 구현시 동작 안됨
        cell.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? AddPostCollectionReusableView else { return UICollectionReusableView() }
        // rx로 구현시 동작 안됨
        footer.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let reactor = reactor else { return .zero }
        if reactor.currentState.images.count < 3 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return .zero
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        guard let reactor = reactor,
              let cell = sender.superview?.superview as? AddPostImageCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        var images = reactor.currentState.images
        images.remove(at: indexPath.item)
        reactor.action.onNext(.imageUpload(images))
    }
    
    @objc func plusButtonTapped() {
        guard let reactor = reactor else { return }
        YPImagePickerController.shared.pickingImages(viewController: self) { images in
            reactor.action.onNext(.imageUpload(images))
        }
    }
    
}
