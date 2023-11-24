//
//  SignInViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

final class SignInViewController: BaseViewController {

    // MARK: - View

    private let contentView = UIView()

    private lazy var idTextField: UITextField = .roundTextField(
        placeHolder: "이메일을 입력하세요",
        keyboardType: .emailAddress
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

    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.configuration = .textButtonConfig(
            title: "리프레시 하기",
            image: .init(systemName: "person"),
            foregroundColor: .systemMint)
        return button
    }()

    private lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballBeat,
            color: .systemOrange,
            padding: 10.0
        )
        return activityIndicator
    }()

    // MARK: - Property

    private let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        view.addGestureRecognizer(backgroundTapGesture)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()

        [
            idTextField, passwordTextField, signInButton, signUpButton,
            refreshButton, activityIndicator
        ].forEach { contentView.addSubview($0) }

        view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        refreshButton.snp.makeConstraints {
            $0.bottom.equalTo(idTextField.snp.top).offset(10)
            $0.size.equalTo(50)
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

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(60)
        }
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: Font.maplestory, size: 20.0)
        ]
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

        refreshButton.rx.tap
            .bind(with: self) { owner, _ in
                let single: Single<NetworkResult<RefreshResponse>>
                single = NetworkManager.shared.request(target: .refresh)
                single.subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let response):
                        print(response.token)
                        KeychainService.shared.create(account: .accessToken, value: response.token)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)

        let input = SignInViewModel.Input(
            emailText: idTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            didSignInButtonTapped: signInButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isSignInPossible
            .asDriver()
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.signInResponse
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    print("로그인 성공")
                    owner.navigationController?.pushViewController(
                        HomeViewController(nibName: nil, bundle: nil),
                        animated: true
                    )
                case .failure(let error):
                    owner.presentAlert(title: error.message)
                }
            }
            .disposed(by: disposeBag)

        output.isLoading
            .asDriver()
            .drive(activityIndicator.rx.isAnimation)
            .disposed(by: disposeBag)

        output.autoSignInResponse
            .bind(with: self) { owner, isLogin in
                if isLogin {
                    print("로그인 성공")
                    owner.navigationController?.pushViewController(
                        HomeViewController(nibName: nil, bundle: nil),
                        animated: true
                    )
                }
            }
            .disposed(by: disposeBag)

        output.autoSignInFailureMessage
            .bind(with: self) { owner, message in
                owner.presentAlert(title: message)
            }
            .disposed(by: disposeBag)
    }

}
