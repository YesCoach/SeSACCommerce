//
//  SignUpViewModel.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import RxSwift
import RxRelay

final class SignUpViewModel: BaseViewModel {

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let nicknameText: Observable<String>
        let phoneNumberText: Observable<String>
        let signUpButtonTouched: Observable<Void>
    }

    struct Output {
        let emailValidation: BehaviorRelay<Bool>
        let errorText: PublishRelay<String>
        let signUpValidation: BehaviorRelay<Bool>
        let signUpResponse: PublishRelay<Result<String, Error>>
    }

    private let signUpInfo = PublishSubject<SignUpInfo>()

    private let loginRepository: LoginRepository
    private let disposeBag = DisposeBag()


    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    func transform(input: Input) -> Output {

        let emailValidation: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let errorText = PublishRelay<String>()
        let signUpValidation = BehaviorRelay<Bool>(value: false)
        let signUpResponse = PublishRelay<Result<String, Error>>()

        // MARK: 이메일 검증
        input.emailText
            .map {
                emailValidation.accept(false)
                errorText.accept("")
                return $0
            }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .flatMapLatest { self.loginRepository.requestValidateEmail(email: $0) }
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success:
                        emailValidation.accept(true)
                        errorText.accept("사용가능한 이메일이에요")
                    case .failure(let error):
                        emailValidation.accept(false)
                        switch error {
                        case .badRequest:
                            errorText.accept("이메일을 입력해주세요")
                        case .conflict:
                            errorText.accept("이미 사용중인 이메일이에요")
                        default:
                            debugPrint(error)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)

        // MARK: 입력값 + 이메일 유효성
        // Observable: Unicast
        // Observable + share: Multicast
        // combineLatest: Combine Observable stream
        let signUpInput = Observable.combineLatest(
            input.emailText,
            input.passwordText,
            input.nicknameText,
            input.phoneNumberText,
            emailValidation
        ).debug()

        // MARK: 회원가입 요청데이터 생성
        let signUpInfo = signUpInput
            .filter { $0.4 }
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .map { email, password, nickname, phoneNumber, validation in
                SignUpInfo(
                    email: email,
                    password: password,
                    nick: nickname,
                    phoneNumber: phoneNumber
                )
            }

        // MARK: 회원가입 가능 여부에 따라 가입하기 버튼 허용
        signUpInput
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && $0.4 }
            .bind(with: self) { owner, isValid in
                signUpValidation.accept(isValid)
            }
            .disposed(by: disposeBag)

        // MARK: 가입하기 버튼 터치시, 회원가입 로직 수행

        // ----O----O----O----O---
        // FlatMap
        // ----O
        // 스트림 이벤트의 결과값들을 flatMap 클로저의 스트림에 넣어준다??

        input.signUpButtonTouched // 터치 이벤트
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpInfo) // ----S------S------S----
            .flatMapLatest { self.loginRepository.requestSignUp(signUpInfo: $0) } // Single<>
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    signUpResponse.accept(.success(response.nick))
                case .failure(let error):
                    signUpResponse.accept(.failure(error))
                }
            }
            .disposed(by: disposeBag)

        return Output(
            emailValidation: emailValidation,
            errorText: errorText,
            signUpValidation: signUpValidation,
            signUpResponse: signUpResponse
        )
    }
}
