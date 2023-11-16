//
//  SignUpViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

final class SignUpViewController: BaseViewController {

    private let contentView: UIView = UIView()

    private lazy var idTextField: UITextField = .roundTextField(
        placeHolder: "이메일을 입력하세요",
        keyboardType: .default
    )

    private lazy var passwordTextField: UITextField = .roundTextField(
        placeHolder: "비밀번호를 입력하세요",
        isPrivacyInput: true
    )

    private lazy var nicknameTextField: UITextField = .roundTextField(
        placeHolder: "닉네임을 입력하세요"
    )

    private lazy var phoneNumTextField: UITextField = .roundTextField(
        placeHolder: "전화번호를 입력하세요",
        keyboardType: .phonePad
    )

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .roundRectConfig(
            title: "가입하기",
            foregroundColor: .systemBlue,
            backgroundColor: .white,
            strokeColor: .systemBlue
        )
        return button
    }()

    private lazy var backgroundTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(didBackgroundTouched)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(backgroundTapGesture)
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "회원가입"
        navigationItem.largeTitleDisplayMode = .always
    }

    override func configureLayout() {
        super.configureLayout()
        [
            idTextField, passwordTextField, nicknameTextField, phoneNumTextField, signUpButton
        ].forEach { contentView.addSubview($0) }

        view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        idTextField.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(idTextField)
            $0.height.equalTo(idTextField)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(idTextField)
            $0.height.equalTo(idTextField)
        }

        phoneNumTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(idTextField)
            $0.height.equalTo(idTextField)
        }

        signUpButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.height.equalTo(50)
        }
    }

    @objc private func didBackgroundTouched() {
        view.endEditing(true)
    }

}
