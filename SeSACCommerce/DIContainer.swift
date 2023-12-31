//
//  DIContainer.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation

final class DIContainer {

    struct Dependency {
        let networkService: NetworkService
    }

    private let dependencies = Dependency(networkService: NetworkManager.shared)

    static let shared = DIContainer()

}

extension DIContainer {

    func makeLoginRepository() -> LoginRepository {
        return DefaultLoginRepository(networkService: dependencies.networkService)
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(loginRepository: makeLoginRepository())
    }

    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(loginRepository: makeLoginRepository())
    }

    func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController(viewModel: makeSignUpViewModel())
    }

    func makeSignInViewController() -> SignInViewController {
        return SignInViewController(viewModel: makeSignInViewModel())
    }

    func makeHomeViewController() -> HomeViewController {
        return HomeViewController()
    }

}
