//
//  SignUpResponse.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/16.
//

import Foundation

struct SignUpResponse: Decodable {
    let id: String
    let email: String
    let nick: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nick
    }
}
