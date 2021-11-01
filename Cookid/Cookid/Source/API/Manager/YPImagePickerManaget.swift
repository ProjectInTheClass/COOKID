//
//  YPImagePickerController.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/27.
//

import Foundation
import YPImagePicker
import Then

class YPImagePickerManager {
    static let shared = YPImagePickerManager()
    
    private var pickerConfig: YPImagePickerConfiguration = {
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
        return config
    }()
    
    private lazy var pickerView: YPImagePicker = {
       let picker = YPImagePicker(configuration: pickerConfig)
        picker.view.backgroundColor = .systemBackground
        return picker
    }()
    
    func pickingImages(viewController: UIViewController, completion: @escaping ([UIImage]) -> Void) {
        pickerView.didFinishPicking { [unowned pickerView] items, _ in
            var selectedImages = [UIImage]()
            for item in items {
                switch item {
                case .photo(let photo):
                    let renderImage = photo.image.resize(newWidth: viewController.view.frame.width)
                    selectedImages.append(renderImage)
                case .video(let video):
                    print(video)
                }
            }
            pickerView.dismiss(animated: true, completion: {
                completion(selectedImages)
            })
        }
        viewController.present(pickerView, animated: true, completion: nil)
    }
}
