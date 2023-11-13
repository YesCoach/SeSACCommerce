//
//  BaseViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNavigationBar()
    }

    deinit {
        print("🗑️ deinit!! - \(String(describing: self))")
    }

    func configureUI() { }
    func configureLayout() { }
    func configureNavigationBar() { }
}
