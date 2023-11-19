//
//  BaseViewController.swift
//  SeSACFoodStory
//
//  Created by 박태현 on 2023/11/13.
//

import UIKit
import SnapKit

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

    func presentAlert(title: String = "", message: String = "") {
        let alert = UIAlertController.simpleConfirmAlert(title: title, message: message)
        present(alert, animated: true)
    }

}
