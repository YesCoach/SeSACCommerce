//
//  UITextField+.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

extension UITextField {

    static func roundTextField(
        placeHolder: String,
        keyboardType: UIKeyboardType = .default,
        isPrivacyInput: Bool = false
    ) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.placeholder = placeHolder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isPrivacyInput
        textField.font = UIFont(name: Font.maplestory, size: 14.0)
        textField.autocapitalizationType = .none // 자동 대문자 변환 기능 제거
        textField.autocorrectionType = .no // 자동완성 기능 제거
        textField.textContentType = .oneTimeCode // 원타임코드 -> 키체인 암호 영역 미노출, 인증코드 형식
        return textField
    }

}
