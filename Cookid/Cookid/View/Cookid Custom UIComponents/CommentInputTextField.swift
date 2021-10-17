//
//  CommentInputTextField.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/17.
//

import UIKit
import SnapKit
import Then

class CommentInputTextField: UIView {
    
    let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let commentTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    let uploadButton = CookidButton().then {
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        $0.imageView?.contentMode = .scaleAspectFill
        $0.buttonImage = image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func makeConstraints() {
        self.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

}
