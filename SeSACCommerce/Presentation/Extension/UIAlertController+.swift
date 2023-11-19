//
//  UIAlertController+.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//


import UIKit.UIAlertController

extension UIAlertController {

    static func simpleConfirmAlert(title: String = "", message: String = "") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)

        let attributeString = NSMutableAttributedString(string: title)
        let font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        attributeString.addAttribute(.font, value: font, range: (title as NSString).range(of: "\(title)"))

        alert.setValue(attributeString, forKey: "attributedTitle")

        alert.addAction(action)
        return alert
    }
}
