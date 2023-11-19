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
        return textField
    }

}
