//
//  NetworkManager.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import Moya
import RxSwift

@frozen enum NetworkResult<T: Decodable> {
    case success(T)
    case failure(LoggableError)
}

protocol NetworkService {
    func request<T: Decodable>(target: SeSACAPI) -> Single<NetworkResult<T>>
}

final class NetworkManager: NetworkService {

    static let shared = NetworkManager()

    private let provider = MoyaProvider<SeSACAPI>(session: Session(interceptor: Interceptor.shared))

    private init() { }

    func request<T: Decodable>(target: SeSACAPI) -> Single<NetworkResult<T>> {
        return Single<NetworkResult<T>>.create { (single) -> Disposable in
            self.provider.request(target) { result in
                switch result {
                case .success(let response):
                    dump(response)
                    guard let data = try? response.map(T.self) else {
                        single(.success(.failure(NetworkError.invalidData)))
                        return
                    }
                    single(.success(.success(data)))
                case .failure(let error):

                    // onError 하면 안되는 이유
                    // 서버 통신 에러 발생(23/11/19_18:00)
                    // onError로 방출하면 구현 방식에 따라 viewModel에서 문제가 발생할 수 있음.
                    // 1. request를 단일 스트림으로 사용할 경우 -> 문제발생 X
                    // 2. request를 flatMap으로 스트림을 합쳐서 사용할 경우
                    // 합쳐진 스트림에서 Error가 발생한거기 때문에 해당 옵저버블은 dispose 됨 -> 구독 끊김

                    guard let statusCode = error.response?.statusCode,
                          let networkError = NetworkError(rawValue: statusCode)
                    else {
                        // single(.failure(error))
                        single(.success(.failure(NetworkError.serverError)))
                        return
                    }
                    single(.success(.failure(networkError)))
                }
            }
            return Disposables.create()
        }
//        .debug(#function, trimOutput: false)
    }
}
