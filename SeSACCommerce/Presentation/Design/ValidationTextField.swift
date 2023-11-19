//
//  ValidationTextField.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import UIKit

class ValidationTextField: UITextField {

    private(set) lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(
        placeholder: String = "",
        isSecureTextEntry: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
    }

    private func configureUI() {
        borderStyle = .roundedRect
        backgroundColor = .secondarySystemBackground
    }

    private func configureLayout() {
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }

}
