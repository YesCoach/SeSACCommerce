//
//  SeSACAPI.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import Moya

enum SeSACAPI {

    static let serverURL: URL = URL(string: Config.testURL)!

    // MARK: - GET

    case refresh

    // MARK: - POST

    case signUp(requestBody: SignUpRequest)
    case validateEmail(requestBody: ValidateEmailRequest)
    case login(requestBody: LoginRequest)

}

extension SeSACAPI: TargetType {

    var baseURL: URL {
        return Self.serverURL
    }

    var path: String {
        switch self {
        case .refresh:
            return "/refresh"
        case .signUp:
            return "/join"
        case .validateEmail:
            return "/validation/email"
        case .login:
            return "/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .refresh:
            return .get
        case .signUp, .validateEmail, .login:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signUp(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .validateEmail(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .login(let requestBody):
            return .requestJSONEncodable(requestBody)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signUp, .validateEmail, .login:
            return [
                "Content-Type": "application/json",
                "SesacKey": APIKey.SeSACKey
            ]
        default:
            return [
                "SesacKey": APIKey.SeSACKey
            ]
        }
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }

}
