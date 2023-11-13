//
//  LoginHomeViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

final class LoginHomeViewController: BaseViewController {

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.configuration = .roundRectConfig(
            title: "이메일로 가입",
            image: .init(systemName: "envelope"),
            foregroundColor: .white,
            backgroundColor: .systemBlue,
            strokeColor: .systemBlue
        )
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .roundRectConfig(
            title: "이메일로 로그인",
            image: .init(systemName: "lock"),
            foregroundColor: .systemBlue,
            backgroundColor: .white,
            strokeColor: .systemBlue
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            signInButton,
            signUpButton
        ].forEach { view.addSubview($0) }

        signInButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }

}

