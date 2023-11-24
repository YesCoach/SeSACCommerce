//
//  UserDefaultsManager.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/23.
//

import Foundation

enum UserDefaultsManager {

    @UserDefault(key: .isFirstLaunch, defaultValue: false)
    /// 최초 앱 실행 여부 값입니다. false일 경우 앱의 첫 화면으로 이동합니다.
    static var isFirstLaunch: Bool

    @UserDefault(key: .isLogined, defaultValue: false)
    /// 유저 로그인 여부 값입니다. false일 경우 로그인화면으로 이동합니다.
    static var isLogined: Bool

}
