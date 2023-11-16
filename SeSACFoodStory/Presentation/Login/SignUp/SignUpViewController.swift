//
//  SignUpViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

final class SignUpViewController: BaseViewController {

    private lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemFill
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "회원가입"
        navigationItem.largeTitleDisplayMode = .never
    }

    override func configureLayout() {
        super.configureLayout()
        [
            idTextField, passwordTextField
        ].forEach { view.addSubview($0) }

        idTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

}
