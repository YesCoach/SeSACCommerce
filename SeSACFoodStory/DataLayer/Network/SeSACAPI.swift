//
//  SeSACAPI.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation
import Moya

enum SeSACAPI {
    case signUp(body: PostJoin)
}

extension SeSACAPI: TargetType {

    var baseURL: URL { URL(string: "http://lslp.sesac.kr:27811/")! }

    var path: String {
        switch self {
        case .signUp:
            return "/join"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signUp(let body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signUp:
            return [
                "Content-Type": "application/json",
                "SesacKey": APIKey.SeSACKey
            ]
        }
    }

}
