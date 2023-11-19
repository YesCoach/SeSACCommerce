//
//  LoginResponse.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let refreshToken: String
}
