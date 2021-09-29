//
//  AddPostImageCollectionViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/25.
//

import UIKit
import ReactorKit
import YPImagePicker

class AddPostImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(AddPostImageCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.postImageCell)
        collectionView.register(AddPostCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")

    }
    
    func bind(reactor: AddPostReactor) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.postImageCell, for: indexPath) as? AddPostImageCollectionViewCell else { return UICollectionViewCell() }
        cell.updateUI(image: images[indexPath.item])
        cell.cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as? AddPostCollectionReusableView else { return UICollectionReusableView() }
        footer.plusButton.addTarget(self, action: #selector(navigateYPImagePicker), for: .touchUpInside)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if images.count < 3 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return .zero
        }
    }
    
    @objc func navigateYPImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.minNumberOfItems = 1
        config.library.maxNumberOfItems = 3
        config.library.numberOfItemsInRow = 3
        config.library.mediaType = YPlibraryMediaType.photo
        config.hidesStatusBar = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Cookid Album"
        config.startOnScreen = .library
        config.wordings.cameraTitle = "카메라"
        config.wordings.cancel = "취소"
        config.wordings.libraryTitle = "앨범"
        config.wordings.next = "선택 완료"
        config.colors.multipleItemsSelectedCircleColor = .systemIndigo
        config.colors.tintColor = .systemIndigo
        config.wordings.warningMaxItemsLimit = "최대 3장을 선택할 수 있어요."
        
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor = .systemBackground
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    self.images.append(photo.image)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: {
                // 리액터에 이미지
                self.collectionView.reloadData()
            })
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapCancel(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? AddPostImageCollectionViewCell else { return }
        let indexPath = collectionView.indexPath(for: cell)!
        images.remove(at: indexPath.item)
        // 리액터에 이미지
        collectionView.reloadData()
    }
}
