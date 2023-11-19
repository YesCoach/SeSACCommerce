//
//  SignInViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {

    // MARK: - View

    private let contentView = UIView()

    private lazy var idTextField: UITextField = .roundTextField(
        placeHolder: "이메일을 입력하세요",
        keyboardType: .default
    )

    private lazy var passwordTextField: UITextField = .roundTextField(
        placeHolder: "비밀번호를 입력하세요",
        isPrivacyInput: true
    )

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .textButtonConfig(
            title: "이메일로 회원가입하기",
            foregroundColor: .tertiaryLabel
        )
        return button
    }()

    private lazy var signInButton: UIButton = {
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

    private lazy var backgroundTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(didBackgroundTouched)
    )

    // MARK: - Property

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        view.addGestureRecognizer(backgroundTapGesture)
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            idTextField, passwordTextField, signInButton, signUpButton
        ].forEach { contentView.addSubview($0) }

        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        idTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom).inset(40)
        }
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonTitle = ""
    }

    @objc private func didBackgroundTouched() {
        view.endEditing(true)
    }
}

private extension SignInViewController {

    func bind() {
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    DIContainer.shared.makeSignUpViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)

        passwordTextField.rx.controlEvent(.touchUpInside)
            .subscribe(with: self) { owner, _ in

            }
    }

}
