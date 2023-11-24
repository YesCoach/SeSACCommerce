//
//  Reactive+.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/24.
//

import Foundation
import NVActivityIndicatorView
import RxSwift

extension Reactive where Base: NVActivityIndicatorView {

    var isAnimation: Binder<Bool> {
        return Binder(self.base) { activityIndicator, isAnimation in
            isAnimation ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

}
