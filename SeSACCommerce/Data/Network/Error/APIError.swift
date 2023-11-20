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
