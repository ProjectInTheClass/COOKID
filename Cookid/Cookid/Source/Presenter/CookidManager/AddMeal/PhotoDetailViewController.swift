//
//  PhotoDetailViewController.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PhotoDetailViewController: UIViewController {
    
    private let photo = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let zoomScrollView = UIScrollView().then {
        $0.zoomScale = 0.5
        $0.minimumZoomScale = 0.5
        $0.maximumZoomScale = 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
        zoomScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func makeConstraints() {
        view.addSubview(zoomScrollView)
        zoomScrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        zoomScrollView.addSubview(photo)
        photo.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension PhotoDetailViewController {
    func rendering(photo: Photo) {
        self.photo.kf.setImage(with: photo.image.url)
    }
}
