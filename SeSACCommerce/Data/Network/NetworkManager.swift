//
//  NetworkManager.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import Moya
import RxSwift

enum NetworkResult<T: Decodable> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Int, Error {
    case invalidData = 0
    case badRequest = 400
    case unAuthorized = 401
    case conflict = 409
    case invalidKey = 420
    case tooManyRequest = 429
    case noResponse = 444
    case serverError = 500
}

protocol NetworkService {
    func request<T: TargetType, K: Decodable>(target: T) -> Single<NetworkResult<K>>
}

final class NetworkManager: NetworkService {

    static let shared = NetworkManager()

    private init() { }

    func request<T: TargetType, K: Decodable>(target: T) -> Single<NetworkResult<K>> {
        return Single<NetworkResult<K>>.create { (single) -> Disposable in
            let provider = MoyaProvider<T>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    dump(response)
                    guard let data = try? response.map(K.self) else {
                        single(.success(.failure(.invalidData)))
                        return
                    }
                    single(.success(.success(data)))
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode,
                          let networkError = NetworkError(rawValue: statusCode)
                    else {
                        single(.failure(error))
                        return
                    }
                    single(.success(.failure(networkError)))
                }
            }
            return Disposables.create()
        }
        .debug(#function, trimOutput: false)
    }
}
