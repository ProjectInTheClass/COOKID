//
//  NoticeDetailViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NoticeDetailViewController: BaseViewController {
    
    var notice: Notice?
    
    private let noticeTitle = UILabel()
    
    private let noticeDate = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    private let contentTextView = UITextView().then {
        $0.isEditable = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if let notice = notice {
            updateUI(notice: notice)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "자세히 보기"
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(noticeTitle)
        view.addSubview(noticeDate)
        view.addSubview(underLine)
        view.addSubview(contentTextView)
         
        noticeTitle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        noticeDate.snp.makeConstraints { make in
            make.top.equalTo(noticeTitle.snp.bottom)
                .offset(10)
            make.right.left.equalTo(noticeTitle)
        }
        
        underLine.snp.makeConstraints { make in
            make.top.equalTo(noticeDate.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.right.left.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(underLine.snp.bottom).offset(20)
            make.left.right.equalTo(noticeTitle)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    func updateUI(notice: Notice) {
        noticeTitle.text = notice.title
        noticeDate.text = notice.date
        contentTextView.text = notice.content
    }
    
}
