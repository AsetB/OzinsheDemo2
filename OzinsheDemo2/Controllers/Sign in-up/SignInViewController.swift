//
//  SignInViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 14.02.2024.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    //- MARK: - Local outlets
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Сәлем"
        title.font = appearance.mainTitleFont
        title.textColor = appearance.c111827_FFFFFF
        title.textAlignment = .left
        return title
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Аккаунтқа кіріңіз"
        label.font = appearance.regular400Font16
        label.textColor = UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = appearance.boldFont14
        label.textColor = appearance.c111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөз"
        label.font = appearance.boldFont14
        label.textColor = appearance.c111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var emailTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Сіздің email"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = appearance.textFieldBorderColor
        textfield.setIcon(UIImage(named: "Message")!)
        return textfield
    }()
    
    lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Сіздің құпия сөзіңіз"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = appearance.textFieldBorderColor
        textfield.setIcon(UIImage(named: "Password")!)
        return textfield
    }()
    
    let showPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Show")
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 18, trailing: 16)
        button.configuration = config
        return button
    }()
    
    let forgotPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let title = "Құпия сөзді ұмыттыңыз ба?"
        //button.setTitle("title", for: .normal)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 14)!]))
        //config.attributedTitle?.foregroundColor = .purpleLabels
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 0)
        config.baseForegroundColor = .purpleLabels
        //button.titleLabel?.textAlignment = .right
        button.contentHorizontalAlignment = .trailing
        button.configuration = config
        return button
    }()
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        let title = "Кіру"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 16)!]))
        config.attributedTitle?.foregroundColor = appearance.FFFFFF
        config.background.backgroundColor = .purpleButtons
        config.background.cornerRadius = appearance.buttonCornerRadius
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "Аккаунтыныз жоқ па? "
        let stringTwo = "Тіркелу"
        var buttonStringOne = NSMutableAttributedString(string: stringOne, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14)!])
        var buttonStringTwo = NSMutableAttributedString(string: stringTwo, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 14)!])
        buttonStringOne.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1)], range: NSRange(location: 0, length: 19))
        buttonStringTwo.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 179/255, green: 118/255, blue: 247/255, alpha: 1)], range: NSRange(location: 0, length: 7))
        buttonStringOne.append(buttonStringTwo)
        button.setAttributedTitle(buttonStringOne, for: .normal)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.FFFFFF_111827
        setupViews()
        setupConstraints()
    }
    
    //- MARK: - Views
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextfield)
        view.addSubview(passwordLabel)
        view.addSubview(passTextfield)
        passTextfield.addSubview(showPassButton)
        view.addSubview(forgotPassButton)
        view.addSubview(enterButton)
        view.addSubview(signUpButton)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(34)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(29)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        passTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        showPassButton.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(56)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        forgotPassButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(passTextfield.snp.bottom).offset(7)
            make.height.equalTo(42)
        }
        enterButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.top.equalTo(passTextfield.snp.bottom).offset(79)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(enterButton.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
    }
    
}
