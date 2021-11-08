//
//  MyPageHeaderViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa
import SafariServices
import MessageUI

class MyPageHeaderViewController: BaseViewController, ViewModelBindable {
    
    // MARK: - UIComponents
    
    let userImage = UserPhotoEditButton().then {
        $0.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        $0.circleColor = .systemYellow
    }
    
    let userNickname = UILabel().then {
        $0.textAlignment = .left
    }
    
    let userType = UILabel().then {
        $0.textColor = .systemYellow
        $0.textAlignment = .left
    }
    
    let userDetermination = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    let userCookidCount = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
 
    let userDinInCount = UILabel().then {
        
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    let userRecipeCount = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageHeaderTableViewCell.self, forCellReuseIdentifier: "appVersion")
        $0.register(MyPageHeaderTableViewCell.self, forCellReuseIdentifier: "email")
        $0.register(MyPageHeaderTableViewCell.self, forCellReuseIdentifier: "privacy")
        $0.register(MyPageHeaderTableViewCell.self, forCellReuseIdentifier: "policy")
        $0.register(MyPageHeaderTableViewCell.self, forCellReuseIdentifier: "openSource")
    }
    
    var viewModel: MyPageViewModel!
    var coordinator: MyPageCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "내 정보"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
    }
  
    override func setupConstraints () {
        super.setupConstraints()
        
        let userNT = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.alignment = .leading
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 5
        }
        
        let userNTD = UIStackView(arrangedSubviews: [userNT, userDetermination]).then {
            $0.alignment = .leading
            $0.distribution = .fillEqually
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        let countSV = UIStackView(arrangedSubviews: [userCookidCount, userDinInCount, userRecipeCount]).then {
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        let userStackView = UIStackView(arrangedSubviews: [userNTD, countSV]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 15
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [userImage, userStackView]).then {
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 15
        }
        
        self.view.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(wholeStackView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
    }

    // MARK: - binding
    
    func bindViewModel() {
        
        viewModel.output.dineInCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userDinInCount.text = "🍚  " + String(count)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.cookidsCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userCookidCount.text = "💸  " + String(count)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.myPostCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userRecipeCount.text = "📝  " + String(count)
            }
            .disposed(by: disposeBag)
        
        userImage.cameraButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                YPImagePickerManager.shared.pickingImages(viewController: self) { images in
                    if let image = images.first {
                        owner.viewModel.input.userImageSelect.accept(image)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.userInfo
            .withUnretained(self)
            .bind(onNext: { (owner, user) in
                owner.userImage.userImageView.setImageWithKf(url: user.image)
                owner.userNickname.text = user.nickname
                owner.userType.text = user.userType.rawValue
                owner.userDetermination.text = user.determination
            })
            .disposed(by: disposeBag)

    }
    
}

extension MyPageHeaderViewController: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "appVersion", for: indexPath) as? MyPageHeaderTableViewCell else { return UITableViewCell() }
            cell.updateUI(title: "소통 페이지")
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "email", for: indexPath) as? MyPageHeaderTableViewCell else { return UITableViewCell() }
            cell.updateUI(title: "이메일로 문의하기")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "privacy", for: indexPath) as? MyPageHeaderTableViewCell else { return UITableViewCell() }
            cell.updateUI(title: "개인 정보 정책")
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "policy", for: indexPath) as? MyPageHeaderTableViewCell else { return UITableViewCell() }
            cell.updateUI(title: "운영 정책")
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "openSource", for: indexPath) as? MyPageHeaderTableViewCell else { return UITableViewCell() }
            cell.updateUI(title: "내 정보 수정하기")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            if let url = URL(string: "https://github.com/ProjectInTheClass/COOKID/discussions") {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        case 1:
            if !MFMailComposeViewController.canSendMail() {
                print("Cannot send Email")
                return
            }
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.delegate = self
            mailComposeViewController.setToRecipients(["phs880623@gmail.com"])
            mailComposeViewController.setSubject("문의할게 있습니다!")
            mailComposeViewController.setMessageBody("문의사항을 기록해 주세요.", isHTML: false)
            present(mailComposeViewController, animated: true, completion: nil)
        case 2:
            let vc = NoticeDetailViewController()
            vc.notice = NoticeManager.notices[1]
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = NoticeDetailViewController()
            vc.notice = NoticeManager.notices[0]
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            coordinator?.navigateUserInfoVC(viewModel: viewModel)
        default:
            break
        }
    }
   
}
