//
//  LoginRepository.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import RxSwift

protocol LoginRepository {

    func requestLogin(
        email: String,
        password: String
    ) -> Single<NetworkResult<LoginResponse>>

    func requestValidateEmail(
        email: String
    ) -> Single<NetworkResult<ValidateEmailResponse>>
    
    func requestSignUp(
        signUpInfo: SignUpInfo
    ) -> Single<NetworkResult<SignUpResponse>>
}
