//
//  CustomResult.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/20.
//

import Foundation

@frozen enum CustomResult<T> {
    case success(T)
    case failure(LoggableError)
}
