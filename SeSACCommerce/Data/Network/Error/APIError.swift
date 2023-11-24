//
//  APIError.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/20.
//

import Foundation

enum ValidateEmailError: Int, LoggableError {
    case badRequest = 400
    case conflict = 409

    var message: String {
        switch self {
        case .badRequest: return "이메일을 입력해주세요"
        case .conflict: return "이미 사용중인 이메일이에요"
        }
    }
}

enum SignUpError: Int, LoggableError {
    case badRequest = 400
    case conflict = 409

    var message: String {
        switch self {
        case .badRequest: return "이메일, 패스워드, 닉네임은 필수에요"
        case .conflict: return "이미 가입된 유저에요"
        }
    }
}

enum SignInError: Int, LoggableError {
    case wrongPassword = 400
    case noUserInfo = 401

    var message: String {
        switch self {
        case .wrongPassword: return "비밀번호가 일치하지 않습니다"
        case .noUserInfo: return "존재하지 않는 계정입니다"
        }
    }
}

enum RefreshError: Int, LoggableError {
    case uncertificatedAccessToken = 401
    case forbidden = 403
    case refreshFailed = 409
    case invalidRefreshToken = 418

    var message: String {
        switch self {
        case .uncertificatedAccessToken: return "인증할 수 없는 액세스 토큰입니다."
        case .forbidden: return "접근권한이 없습니다."
        case .refreshFailed: return "액세스 토큰이 만료되지 않았습니다."
        case .invalidRefreshToken: return "리프레시 토큰이 만료되었습니다. 다시 로그인 해주세요."
        }
    }
}
