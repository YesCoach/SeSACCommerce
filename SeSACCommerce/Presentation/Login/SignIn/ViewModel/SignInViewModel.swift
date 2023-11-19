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

    enum SignInError: Error {
        case wrongPassword
        case noUserInfo

        var message: String {
            switch self {
            case .wrongPassword: return "비밀번호가 일치하지 않습니다"
            case .noUserInfo: return "존재하지 않는 계정입니다"
            }
        }
    }

    struct Input {
        let emailText: Observable<String>
        let password: Observable<String>
        let didSignInButtonTapped: Observable<Void>
    }

    struct Output {
        let isSignInPossible: BehaviorRelay<Bool>
        let signInResponse: PublishRelay<Result<Void, SignInError>>
    }

    private let disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let isSignInPossible = BehaviorRelay(value: false)
        let signInResponse = PublishRelay<Result<Void, SignInError>>()

        let signInRequest = Observable.combineLatest(input.emailText, input.password)

        signInRequest
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind { isPossible in
                isSignInPossible.accept(isPossible)
            }
            .disposed(by: disposeBag)

//        input.didSignInButtonTapped
//            .withLatestFrom(signInRequest)
//            .flatMapLatest {  }


        return Output(isSignInPossible: isSignInPossible, signInResponse: signInResponse)
    }
}

