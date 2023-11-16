//
//  UIButton.Configuration+.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

extension UIButton.Configuration {

    static func roundRectConfig(
        title: String = "",
        image: UIImage? = nil,
        foregroundColor: UIColor,
        backgroundColor: UIColor,
        strokeColor: UIColor = .black
    ) -> UIButton.Configuration {
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = foregroundColor
        config.baseBackgroundColor = backgroundColor
        config.background.strokeColor = strokeColor
        config.attributedTitle = AttributedString(
            title,
            attributes: .init(
                [.font: UIFont.systemFont(ofSize: 15.0, weight: .bold)]
            )
        )
        config.cornerStyle = .medium
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 5.0
        return config
    }

    static func textButtonConfig(
        title: String = "",
        image: UIImage? = nil,
        foregroundColor: UIColor
    ) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            title,
            attributes: .init(
                [.font: UIFont.systemFont(ofSize: 14.0, weight: .semibold)]
            )
        )
        config.baseForegroundColor = foregroundColor
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 5.0
        return config
    }

}
