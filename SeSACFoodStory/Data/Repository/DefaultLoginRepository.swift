//
//  DefaultLoginRepository.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import RxSwift

final class DefaultLoginRepository {

    private let networkService: NetworkService 

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

}

extension DefaultLoginRepository: LoginRepository {
    func requestValidateEmail(email: String) -> Single<NetworkResult<ValidateEmailResponse>> {
        let requestBody = ValidateEmailRequest(email: email)
        return networkService
            .request(target: SeSACAPI.validateEmail(requestBody: requestBody))
    }
    
    func requestSignUp(
        email: String,
        password: String,
        nickname: String,
        phoneNum: String? = nil,
        birthDay: String? = nil
    ) -> Single<NetworkResult<SignUpResponse>> {
        let requestBody = SignUpRequest(
            email: email,
            password: password,
            nick: nickname,
            phoneNum: phoneNum,
            birthDay: birthDay
        )
        return networkService
            .request(target: SeSACAPI.signUp(requestBody: requestBody))
    }
    
    
}
