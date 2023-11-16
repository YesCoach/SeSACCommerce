//
//  LoginRepository.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func requestValidateEmail(
        email: String
    ) -> Single<NetworkResult<ValidateEmailResponse>>
    
    func requestSignUp(
        email: String,
        password: String,
        nickname: String,
        phoneNum: String?,
        birthDay: String?
    ) -> Single<NetworkResult<SignUpResponse>>
}
