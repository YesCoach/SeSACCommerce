//
//  SignInViewModel.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import Foundation
import RxSwift
import RxRelay

final class SignInViewModel: BaseViewModel {

    struct Input {
        let emailText: Observable<String>
        let password: Observable<String>
        let didSignInButtonTapped: Observable<Void>
    }

    struct Output {
        let isSignInPossible: BehaviorRelay<Bool>
        let signInResponse: PublishRelay<CustomResult<Void>>
        let autoSignInResponse: PublishRelay<Bool>
        let autoSignInFailureMessage: PublishRelay<String>

        let isLoading: BehaviorRelay<Bool>
    }

    private let loginRepository: LoginRepository
    private let disposeBag = DisposeBag()

    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    func transform(input: Input) -> Output {
        let isSignInPossible = BehaviorRelay(value: false)
        let signInResponse = PublishRelay<CustomResult<Void>>()
        let autoSignInResponse = PublishRelay<Bool>()
        let autoSignInFailureMessage = PublishRelay<String>()
        let isLoading = BehaviorRelay(value: false)

        let signInInput = Observable.combineLatest(input.emailText, input.password)
            .share()

        signInInput
            .map { return (!$0.0.isEmpty && !$0.1.isEmpty) }
            .bind { isPossible in
                isSignInPossible.accept(isPossible)
            }
            .disposed(by: disposeBag)

        input.didSignInButtonTapped
            .withLatestFrom(signInInput)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest {
                isLoading.accept(true)
                return self.loginRepository.requestLogin(email: $0.0, password: $0.1)
            }
            .subscribe(with: self) { owner, result in
                isLoading.accept(false)
                switch result {
                case .success(let response):
                    KeychainService.shared.create(
                        account: .accessToken,
                        value: response.token
                    )
                    KeychainService.shared.create(
                        account: .refreshToken,
                        value: response.refreshToken
                    )
                    UserDefaultsManager.isLogined = true
                    signInResponse.accept(.success(()))
                case .failure(let error):
                    guard let signInError = SignInError(rawValue: error.rawValue) else {
                        signInResponse.accept(.failure(error))
                        return
                    }
                    signInResponse.accept(.failure(signInError))
                }
            }
            .disposed(by: disposeBag)

        if let _ = KeychainService.shared.accessToken,
           let _ = KeychainService.shared.refreshToken {
            isLoading.accept(true)
            loginRepository.requestRefreshToken()
                .subscribe(with: self) { owner, result in
                    isLoading.accept(false)
                    switch result {
                    case .success(let response):
                        KeychainService.shared.create(
                            account: .accessToken,
                            value: response.token
                        )
                        autoSignInResponse.accept(true)
                    case .failure(let error):
                        guard let refreshError = RefreshError(rawValue: error.rawValue),
                              refreshError == .refreshFailed
                        else {
                            let keychainItems: [KeychainService.KeychainItem] = [
                                .accessToken,
                                .refreshToken,
                                .userID,
                                .userPassword
                            ]
                            keychainItems.forEach {
                                KeychainService.shared.delete(account: $0)
                            }
                            UserDefaultsManager.isLogined = false
                            autoSignInFailureMessage.accept("로그아웃되었습니다. 다시 로그인해주세요.")
                            return
                        }
                        autoSignInResponse.accept(true)
                    }
                }
                .disposed(by: disposeBag)
        }

        return Output(
            isSignInPossible: isSignInPossible,
            signInResponse: signInResponse,
            autoSignInResponse: autoSignInResponse,
            autoSignInFailureMessage: autoSignInFailureMessage,
            isLoading: isLoading
        )
    }
}

