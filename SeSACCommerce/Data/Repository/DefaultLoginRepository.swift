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

    func requestLogin(email: String, password: String) -> Single<NetworkResult<LoginResponse>> {
        let requestBody = LoginRequest(email: email, password: password)
        return networkService.request(target: SeSACAPI.login(requestBody: requestBody))
    }

    func requestValidateEmail(email: String) -> Single<NetworkResult<ValidateEmailResponse>> {
        let requestBody = ValidateEmailRequest(email: email)
        return networkService
            .request(target: SeSACAPI.validateEmail(requestBody: requestBody))
    }
    
    func requestSignUp(
        signUpInfo: SignUpInfo
    ) -> Single<NetworkResult<SignUpResponse>> {
        let requestBody = SignUpRequest(
            email: signUpInfo.email,
            password: signUpInfo.password,
            nick: signUpInfo.nick,
            phoneNum: signUpInfo.phoneNumber,
            birthDay: signUpInfo.birthDay
        )
        return networkService
            .request(target: SeSACAPI.signUp(requestBody: requestBody))
    }
    
    func requestRefreshToken() -> Single<NetworkResult<RefreshResponse>> {
        return networkService.request(target: SeSACAPI.refresh)
    }


}
