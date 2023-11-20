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
    }

    private let loginRepository: LoginRepository
    private let disposeBag = DisposeBag()

    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    func transform(input: Input) -> Output {
        let isSignInPossible = BehaviorRelay(value: false)
        let signInResponse = PublishRelay<CustomResult<Void>>()

        let signInInput = Observable.combineLatest(input.emailText, input.password)
            .share()

        signInInput
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind { isPossible in
                isSignInPossible.accept(isPossible)
            }
            .disposed(by: disposeBag)

        input.didSignInButtonTapped
            .withLatestFrom(signInInput)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { self.loginRepository.requestLogin(email: $0.0, password: $0.1) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    signInResponse.accept(.success(()))
                    KeychainService.shared.create(account: .accessToken, value: response.token)
                    KeychainService.shared.create(account: .refreshToken, value: response.refreshToken)
                case .failure(let error):
                    guard let signInError = SignInError(rawValue: error.rawValue) else {
                        signInResponse.accept(.failure(error))
                        return
                    }
                    signInResponse.accept(.failure(signInError))
                }
            }
            .disposed(by: disposeBag)

        return Output(
            isSignInPossible: isSignInPossible,
            signInResponse: signInResponse
        )
    }
}

