//
//  AddPostImageCollectionViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/25.
//

import UIKit
import YPImagePicker

class AddPostImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ViewModelBindable, StoryboardBased {
    
    var viewModel: PostViewModel!
    
    var images = [UIImage]()
    
    let imagePageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = .darkGray
        $0.currentPageIndicatorTintColor = .cyan
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(AddPostImageCollectionViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER.postImageCell)
        collectionView.register(AddPostCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")

        collectionView.addSubview(imagePageControl)
        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        imagePageControl.numberOfPages = images.count + 1
    }
    
    func bindViewModel() {
        viewModel.input.postImages
            .bind { images in
                print(images.count)
            }
            .disposed(by: rx.disposeBag)
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
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        self.imagePageControl.currentPage = page
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
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc func navigateYPImagePicker() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 3
        
        let picker = YPImagePicker(configuration: config)
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
                self.viewModel.input.postImages.accept(self.images)
                self.collectionView.reloadData()
            })
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapCancel(_ sender: UIButton) {
        let cell = sender.superview?.superclass as? AddPostImageCollectionViewCell
        
        images.remove(at: <#T##Int#>)
        print("cancel")
    }
}
