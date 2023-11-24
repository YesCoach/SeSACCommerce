//
//  UserDefaultsWrapper.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/23.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    let key: UserDefaultsKey
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key.rawValue) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }

}
