//
//  Interceptor.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import Foundation
import Alamofire
import RxSwift

final class Interceptor: RequestInterceptor {

    static let shared = Interceptor()

    private init() {}

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        let path = urlRequest.url?.path(percentEncoded: true)

        dump(urlRequest)

        guard urlRequest.url?.absoluteString.hasPrefix(SeSACAPI.serverURL.absoluteString) == true,
              ["/join", "/login", "/validation"].contains(path) == false,
              let accessToken = KeychainService.shared.accessToken
        else {
            completion(.success(urlRequest))
            return
        }

        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")

        if ["/refresh"].contains(path) {
            let refreshToken = KeychainService.shared.refreshToken
            urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh")
        }

        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }

        // 토큰 갱신 API 호출
        NetworkManager.shared.request(target: SeSACAPI.refresh)
            .subscribe(with: self) { (owner: Interceptor, result: NetworkResult<RefreshResponse>) in
                switch result {
                case .success(let response):
                    KeychainService.shared.create(
                        account: .accessToken,
                        value: response.token
                    )
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
            .dispose()
    }
}
