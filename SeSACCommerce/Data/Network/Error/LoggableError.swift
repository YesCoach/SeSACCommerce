//
//  LoggableError.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/20.
//

import Foundation

protocol LoggableError: Error {
    var rawValue: Int { get }
    var message: String { get }
}
