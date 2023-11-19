//
//  LoginRequest.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
