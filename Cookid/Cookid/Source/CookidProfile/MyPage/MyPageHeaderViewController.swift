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
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "appVersion")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "email")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "privacy")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "policy")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "openSource")
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.separatorColor = .clear
    }
    
    var viewModel: MyPageViewModel!
    var coordinator: MyPageCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(updateUserInfomation))
        view.backgroundColor = .systemBackground
        title = "내 정보"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func updateUserInfomation() {
        coordinator?.navigateUserInfoVC(viewModel: viewModel)
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

extension MyPageHeaderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "appVersion", for: indexPath)
            cell.textLabel?.text = "공지사항"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "email", for: indexPath)
            cell.textLabel?.text = "이메일"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "privacy", for: indexPath)
            cell.textLabel?.text = "개인정보정책"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "policy", for: indexPath)
            cell.textLabel?.text = "운영정책"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "openSource", for: indexPath)
            cell.textLabel?.text = "오픈소스"
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            print("first")
        case 1:
            print("secont")
        case 2:
            print("third")
        case 3:
            print("fourth")
        case 4:
            print("fifth")
        default:
            break
        }
    }
   
}
