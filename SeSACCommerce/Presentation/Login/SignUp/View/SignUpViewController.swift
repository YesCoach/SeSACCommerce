//
//  SignUpViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {

    private let contentView: UIView = UIView()

    private lazy var emailTextField: ValidationTextField = ValidationTextField(
        placeholder: "이메일을 입력하세요"
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

    private let viewModel: SignUpViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(backgroundTapGesture)
        bind()
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
            emailTextField, passwordTextField, nicknameTextField, phoneNumTextField, signUpButton
        ].forEach { contentView.addSubview($0) }

        view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        emailTextField.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(emailTextField)
            $0.height.equalTo(emailTextField)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(emailTextField)
            $0.height.equalTo(emailTextField)
        }

        phoneNumTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(emailTextField)
            $0.height.equalTo(emailTextField)
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

private extension SignUpViewController {

    func bind() {
        let input = SignUpViewModel.Input(
            emailText: emailTextField.rx.controlEvent(.editingChanged)
                .withLatestFrom(emailTextField.rx.text.orEmpty.asObservable()),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            nicknameText: nicknameTextField.rx.text.orEmpty.asObservable(),
            phoneNumberText: phoneNumTextField.rx.text.orEmpty.asObservable(),
            signUpButtonTouched: signUpButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.signUpValidation
            .asDriver()
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.signUpResponse
            .asDriver(onErrorJustReturn: .failure(NetworkError.badRequest))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let nick):
                    let vc = SignUpSuccessViewController(nickname: nick)
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        output.emailValidation
            .asDriver()
            .map { $0 ? UIColor.systemGreen : UIColor.systemRed }
            .drive(emailTextField.messageLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.errorText
            .asDriver(onErrorJustReturn: "")
            .drive(emailTextField.messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
