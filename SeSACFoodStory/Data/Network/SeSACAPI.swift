//
//  SeSACAPI.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import Moya

enum SeSACAPI {
    case signUp(requestBody: SignUpRequest)
    case validateEmail(requestBody: ValidateEmailRequest)
}

extension SeSACAPI: TargetType {

    var baseURL: URL { URL(string: "http://lslp.sesac.kr:27820")! }

    var path: String {
        switch self {
        case .signUp:
            return "/join"
        case .validateEmail:
            return "/validation/email"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp, .validateEmail:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signUp(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .validateEmail(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signUp, .validateEmail:
            return [
                "Content-Type": "application/json",
                "SesacKey": APIKey.SeSACKey
            ]
        }
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }

}
