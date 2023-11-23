//
//  HomeViewModel.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/22.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel: BaseViewModel {

    struct Input {
        let postButtonTouched: Observable<Void>
    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
