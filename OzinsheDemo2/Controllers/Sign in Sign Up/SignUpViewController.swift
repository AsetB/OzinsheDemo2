//
//  SignUpViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 15.02.2024.
//

import UIKit
import SnapKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

class SignUpViewController: UIViewController {
    //- MARK: - Variables
    var errorLabelTopToRepeatPassTFBottom: Constraint? = nil
    var signUpButtonTopToRepeatPassTFBottom: Constraint? = nil
    var signUpButtonTopToErrorLabelBottom: Constraint? = nil
    var errorMailFormatLabelTopToEmailTFBottom: Constraint? = nil
    var passLabelTopToEmailTFBottom: Constraint? = nil
    var passLabelTopToErrorMailTakenLabelBottom: Constraint? = nil
    
    //- MARK: - Local outlets
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Тіркелу"
        title.font = appearance.mainTitleFont
        title.textColor = appearance.c111827_FFFFFF
        title.textAlignment = .left
        return title
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Деректерді толтырыңыз"
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
    
    lazy var repeatPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөзді қайталаңыз"
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
        textfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
        textfield.setIcon(UIImage(named: "Message")!)
        textfield.addTarget(self,
                            action: #selector(emailTextfieldEditingChange),
                            for: .editingChanged)
        textfield.addTarget(self,
                            action: #selector(emailTextfieldEditingDidBegin),
                            for: .editingDidBegin)
        textfield.addTarget(self,
                            action: #selector(emailTextfieldEditingDidEnd),
                            for: .editingDidEnd)
        //textfield.textContentType = .emailAddress
        textfield.keyboardType = .emailAddress
        return textfield
    }()
    
    lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Сіздің құпия сөзіңіз"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
        textfield.setIcon(UIImage(named: "Password")!)
        textfield.keyboardType = .default
        //textfield.textContentType = .password
        textfield.isSecureTextEntry = true
        textfield.addTarget(self,
                            action: #selector(passTextfieldEditingDidBegin),
                            for: .editingDidBegin)
        textfield.addTarget(self,
                            action: #selector(passTextfieldEditingDidEnd),
                            for: .editingDidEnd)
        textfield.tintColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
        return textfield
    }()
    
    lazy var repeatPassTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Сіздің құпия сөзіңіз"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
        textfield.setIcon(UIImage(named: "Password")!)
        textfield.keyboardType = .default
        //textfield.textContentType = .password
        textfield.isSecureTextEntry = true
        textfield.addTarget(self,
                            action: #selector(repeatPassTextfieldEditingDidBegin),
                            for: .editingDidBegin)
        textfield.addTarget(self,
                            action: #selector(repeatPassTextfieldEditingDidEnd),
                            for: .editingDidEnd)
        textfield.tintColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
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
    
    let showRepeatPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Show")
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 18, trailing: 16)
        button.configuration = config
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        let title = "Тіркелу"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 16)!]))
        config.attributedTitle?.foregroundColor = appearance.FFFFFF
        config.background.backgroundColor = .purpleButtons
        config.background.cornerRadius = appearance.buttonCornerRadius
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    lazy var goToSignInButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "Сізде аккаунт бар ма? "
        let stringTwo = "Кіру"
        var buttonStringOne = NSMutableAttributedString(string: stringOne, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14)!])
        var buttonStringTwo = NSMutableAttributedString(string: stringTwo, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 14)!])
        buttonStringOne.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1)], range: NSRange(location: 0, length: stringOne.count))
        buttonStringTwo.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 179/255, green: 118/255, blue: 247/255, alpha: 1)], range: NSRange(location: 0, length: stringTwo.count))
        buttonStringOne.append(buttonStringTwo)
        button.setAttributedTitle(buttonStringOne, for: .normal)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    lazy var errorMailFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "Қате формат"
        label.textColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1)
        label.font = appearance.regular400Font14
        return label
    }()
    
    lazy var errorMailTakenLabel: UILabel = {
        let label = UILabel()
        label.text = "Мұндай email-ы бар пайдаланушы тіркелген"
        label.textColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1)
        label.font = appearance.regular400Font14
        label.textAlignment = .center
        return label
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.FFFFFF_111827
        navigationItem.title = " "
        setupViews()
        setupConstraints()
        setupButtonActions()
        hideKeyboardWhenTappedAround()
    }
    //- MARK: - Views
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextfield)
        view.addSubview(passwordLabel)
        view.addSubview(passTextfield)
        view.addSubview(showPassButton)
        view.addSubview(repeatPasswordLabel)
        view.addSubview(repeatPassTextfield)
        view.addSubview(showRepeatPassButton)
        view.addSubview(signUpButton)
        view.addSubview(goToSignInButton)
        view.addSubview(errorMailTakenLabel)
        errorMailTakenLabel.isHidden = true
        view.addSubview(errorMailFormatLabel)
        errorMailFormatLabel.isHidden = true
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
            self.passLabelTopToEmailTFBottom = make.top.equalTo(emailTextfield.snp.bottom).offset(13).priority(.high).constraint
            self.passLabelTopToErrorMailTakenLabelBottom = make.top.equalTo(errorMailFormatLabel.snp.bottom).offset(16).priority(.low).constraint
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
            make.trailing.equalTo(passTextfield.snp.trailing)
            make.centerY.equalTo(passTextfield.snp.centerY)
        }
        repeatPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passTextfield.snp.bottom).offset(13)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        repeatPassTextfield.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        showRepeatPassButton.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(56)
            make.trailing.equalTo(repeatPassTextfield.snp.trailing)
            make.centerY.equalTo(repeatPassTextfield.snp.centerY)
        }
        signUpButton.snp.makeConstraints { make in
            self.signUpButtonTopToRepeatPassTFBottom = make.top.equalTo(repeatPassTextfield.snp.bottom).offset(40).priority(.high).constraint
            self.signUpButtonTopToErrorLabelBottom = make.top.equalTo(errorMailTakenLabel.snp.bottom).offset(40).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        goToSignInButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        errorMailTakenLabel.snp.makeConstraints { make in
            self.errorLabelTopToRepeatPassTFBottom = make.top.equalTo(repeatPassTextfield.snp.bottom).offset(32).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        errorMailFormatLabel.snp.makeConstraints { make in
            self.errorMailFormatLabelTopToEmailTFBottom = make.top.equalTo(emailTextfield.snp.bottom).offset(16).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
    }
    
    func turnOnEmailFormatError() {
        errorMailFormatLabel.isHidden = false
        errorMailFormatLabelTopToEmailTFBottom?.update(priority: .high) // start low
        passLabelTopToEmailTFBottom?.update(priority: .low) // start high
        passLabelTopToErrorMailTakenLabelBottom?.update(priority: .high) // start low
        emailTextfield.layer.borderColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1.0).cgColor
    }
    func turnOffEmailFormatError() {
        errorMailFormatLabel.isHidden = true
        errorMailFormatLabelTopToEmailTFBottom?.update(priority: .low) // start low
        passLabelTopToEmailTFBottom?.update(priority: .high) // start high
        passLabelTopToErrorMailTakenLabelBottom?.update(priority: .low) //start low
        emailTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    //- MARK: - Setup Button Actions
    func setupButtonActions() {
        showPassButton.addTarget(self, action: #selector(showPass), for: .touchUpInside)
        showRepeatPassButton.addTarget(self, action: #selector(showRepeatPass), for: .touchUpInside)
        goToSignInButton.addTarget(self, action: #selector(showSignInScreen), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
    }
    @objc func showPass() {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
    }
    @objc func showRepeatPass() {
        repeatPassTextfield.isSecureTextEntry = !repeatPassTextfield.isSecureTextEntry
    }
    @objc func showSignInScreen() {
        let signupVC = SignInViewController()
        navigationController?.show(signupVC, sender: self)
    }
    @objc func signUpAction() {
        let email = emailTextfield.text!
        let password = passTextfield.text!
        let repeatedPass = repeatPassTextfield.text!
        
        if email.isEmpty || password.isEmpty || repeatedPass.isEmpty {
            return
        }
        
        if !emailTextfield.text!.isEmail(){
            showAlertMessage(title: "Wrong email format", message: "Please write correct email")
            emailTextfield.text = ""
            turnOffEmailFormatError()
            return
        }
        
        if password == repeatedPass {
            
            SVProgressHUD.show()
            
            let parameters = ["email": email, "password": password]
            
            AF.request(URLs.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                if response.response?.statusCode == 400 {
                    self.errorMailTakenLabel.isHidden = false
                    self.errorLabelTopToRepeatPassTFBottom?.update(priority: .high) // start low
                    self.signUpButtonTopToRepeatPassTFBottom?.update(priority: .low) // start high
                    self.signUpButtonTopToErrorLabelBottom?.update(priority: .high) //start low
                    return
                }
                
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    if let token = json["accessToken"].string {
                        Storage.sharedInstance.accessToken = token
                        UserDefaults.standard.set(token, forKey: "accessToken")
                        self.startApp()
                    } else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                    }
                } else {
                    var ErrorString = "CONNECTION_ERROR"
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "PASS_NOT_MATCH")
        }
    }
    //- MARK: - TextField Actions
    @objc func emailTextfieldEditingChange(){
        if !emailTextfield.text!.isEmail() {
            turnOnEmailFormatError()
        } else {
            turnOffEmailFormatError()
        }
        
        if emailTextfield.text!.isEmpty {
            turnOffEmailFormatError()
        }
    }
    @objc func emailTextfieldEditingDidBegin(){
        emailTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
        errorMailTakenLabel.isHidden = true
        errorLabelTopToRepeatPassTFBottom?.update(priority: .low) // start low
        signUpButtonTopToRepeatPassTFBottom?.update(priority: .high) // start high
        signUpButtonTopToErrorLabelBottom?.update(priority: .low) //start low
        turnOffEmailFormatError()
    }
    @objc func emailTextfieldEditingDidEnd(){
        emailTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func passTextfieldEditingDidBegin(){
        passTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func passTextfieldEditingDidEnd(){
        passTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func repeatPassTextfieldEditingDidBegin(){
        repeatPassTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func repeatPassTextfieldEditingDidEnd(){
        repeatPassTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    //- MARK: - Dark mode(for CGColor)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch self.traitCollection.userInterfaceStyle {
        case .dark:
            print("dark")
            emailTextfield.layer.borderColor = CGColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
            passTextfield.layer.borderColor = CGColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
            repeatPassTextfield.layer.borderColor = CGColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
        case .light:
            print("light")

            emailTextfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
            passTextfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
            repeatPassTextfield.layer.borderColor = CGColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1)
        case .unspecified:
            print("unspecified")
        @unknown default:
            fatalError()
        }
    }
    
    func startApp() {
        let tabViewController = TabBarController()
        tabViewController.modalPresentationStyle = .fullScreen
        self.present(tabViewController, animated: true, completion: nil)
    }
}
