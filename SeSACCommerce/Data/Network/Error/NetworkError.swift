//
//  NetworkError.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/20.
//

import Foundation

enum NetworkError: Int, LoggableError {
    case invalidData = 0
    case badRequest = 400
    case unAuthorized = 401
    case conflict = 409
    case invalidKey = 420
    case tooManyRequest = 429
    case noResponse = 444
    case serverError = 500

    var message: String {
        switch self {
        case .badRequest: return "잘못된 요청입니다"
        case .serverError: return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요"
        case .conflict: return "충돌이 발생했습니다"
        default: return ""
        }
    }
}
