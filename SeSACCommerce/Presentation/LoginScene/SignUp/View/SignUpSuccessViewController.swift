//
//  SignUpSuccessViewController.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import UIKit
import RxCocoa
import RxSwift

final class SignUpSuccessViewController: BaseViewController {

    private lazy var informLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        \(nickname)님 어서오세요!!
                        """
        label.font = UIFont(name: Font.maplestory, size: 18.0)
        label.textColor = .label
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configuration = .roundRectConfig(
            title: "로그인하기",
            foregroundColor: .white,
            backgroundColor: .systemBlue,
            strokeColor: .systemBlue
        )
        return button
    }()

    private let nickname: String
    private let disposeBag = DisposeBag()

    init(nickname: String) {
        self.nickname = nickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()
        [
            informLabel, loginButton
        ].forEach { view.addSubview($0) }

        informLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.hidesBackButton = true
        navigationItem.title = "🎉 회원가입 완료"
        navigationItem.largeTitleDisplayMode = .always
    }

    private func bind() {
        loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
