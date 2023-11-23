//
//  HomeViewController.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/22.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = KeychainService.shared.read(account: .userID)
        label.font = UIFont(name: Font.maplestory, size: 15.0)
        return label
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = KeychainService.shared.read(account: .userPassword)
        label.font = UIFont(name: Font.maplestory, size: 15.0)
        return label
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = KeychainService.shared.read(account: .accessToken)
        label.font = UIFont(name: Font.maplestory, size: 15.0)
        return label
    }()

    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.configuration = .textButtonConfig(title: "포스트 작성하기", foregroundColor: .systemOrange)
        return button
    }()

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()
        [
            idLabel, passwordLabel, nicknameLabel
        ].forEach { view.addSubview($0) }

        idLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
        }

        passwordLabel.snp.makeConstraints {
            $0.centerX.equalTo(idLabel)
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalTo(idLabel)
            $0.top.equalTo(passwordLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
    }

    private func bind() {
        let postButtonTouched = postButton.rx.tap.asObservable()
        
    }
}
