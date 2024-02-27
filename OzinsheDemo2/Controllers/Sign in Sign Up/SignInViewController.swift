//
//  SignInViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 14.02.2024.
//

import UIKit
import SnapKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import Localize_Swift

class SignInViewController: UIViewController {
    
    //- MARK: - Variables
    var errorLabelTopToEmailTFBottom: Constraint? = nil
    var passLabelTopToEmailTFBottom: Constraint? = nil
    var errorLabelBottomToPassLabelTop: Constraint? = nil
    
    //- MARK: - Local outlets
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.FFFFFF_111827
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "HELLO".localized()
        title.font = appearance.mainTitleFont
        title.textColor = appearance.c111827_FFFFFF
        title.textAlignment = .left
        return title
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "LOGIN_INTO_ACCOUNT".localized()
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
        label.text = "PASSWORD".localized()
        label.font = appearance.boldFont14
        label.textColor = appearance.c111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var emailTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "YOUR_EMAIL".localized()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
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
        textfield.textContentType = .emailAddress
        textfield.keyboardType = .emailAddress
        textfield.autocapitalizationType = .none
        textfield.tintColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
        textfield.backgroundColor = UIColor.FFFFFF_1_C_2431
        return textfield
    }()
    
    lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "YOUR_PASSWORD".localized()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
        textfield.setIcon(UIImage(named: "Password")!)
        textfield.keyboardType = .default
        textfield.textContentType = .password
        textfield.isSecureTextEntry = true
        textfield.addTarget(self,
                            action: #selector(passTextfieldEditingDidBegin),
                            for: .editingDidBegin)
        textfield.addTarget(self,
                            action: #selector(passTextfieldEditingDidEnd),
                            for: .editingDidEnd)
        textfield.tintColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
        textfield.backgroundColor = UIColor.FFFFFF_1_C_2431
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
        let title = "FORGOT_YOUR_PASSWORD".localized()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 14)!]))
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 0)
        config.baseForegroundColor = .purpleLabels
        button.contentHorizontalAlignment = .trailing
        button.configuration = config
        return button
    }()
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        let title = "LOGIN".localized()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 16)!]))
        config.attributedTitle?.foregroundColor = appearance.FFFFFF
        config.background.backgroundColor = .purpleButtons
        config.background.cornerRadius = appearance.buttonCornerRadius
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    lazy var goToSignUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "NO_ACCOUNT".localized()
        let stringTwo = "SIGN_UP".localized()
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
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR".localized()
        label.font = appearance.medium500Font14
        label.textColor = ._9_CA_3_AF
        label.textAlignment = .center
        return label
    }()
    
    lazy var appleIDSignUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        //title
        let title = "SIGNUP_APPLE".localized()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 16)!]))
        //config.attributedTitle?.foregroundColor = ._111827_FFFFFF //не работает
        
        //button
        config.baseBackgroundColor = .FFFFFF_4_B_5563
        config.baseForegroundColor = ._111827_FFFFFF
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.Border.appleGoogleSignInButton.cgColor
        button.layer.cornerRadius = appearance.buttonCornerRadius
        button.clipsToBounds = true
        
        //logo
        config.image = UIImage(named: "apple-logo")
        config.imagePadding = 10
        
        button.contentHorizontalAlignment = .center
        button.configuration = config
    
        return button
    }()
    
    lazy var googleSignUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        //title
        let title = "SIGNUP_GOOGLE".localized()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 16)!]))
        //button
        config.baseBackgroundColor = .FFFFFF_4_B_5563
        config.baseForegroundColor = ._111827_FFFFFF
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.Border.appleGoogleSignInButton.cgColor
        button.layer.cornerRadius = appearance.buttonCornerRadius
        button.clipsToBounds = true
        //logo
        config.image = UIImage(named: "GoogleLogo")
        config.imagePadding = 10
        
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "WRONG_FORMAT".localized()
        label.textColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1)
        label.font = appearance.regular400Font14
        return label
    }()
    
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.FFFFFF_111827
        navigationItem.title = ""
        setupViews()
        setupConstraints()
        setupButtonActions()
        hideKeyboardWhenTappedAround()
        setupBorderColor()
    }
    
    //- MARK: - Dark mode(for CGColor)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupBorderColor()
    }
    
    func setupBorderColor(){
        emailTextfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
        passTextfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
        appleIDSignUpButton.layer.borderColor = UIColor.Border.appleGoogleSignInButton.cgColor
        googleSignUpButton.layer.borderColor = UIColor.Border.appleGoogleSignInButton.cgColor
    }

    //- MARK: - Views
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextfield)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passTextfield)
        contentView.addSubview(showPassButton)
        contentView.addSubview(forgotPassButton)
        contentView.addSubview(enterButton)
        contentView.addSubview(goToSignUpButton)
        contentView.addSubview(orLabel)
        contentView.addSubview(appleIDSignUpButton)
        contentView.addSubview(googleSignUpButton)
        contentView.addSubview(errorLabel)
        errorLabel.isHidden = true
    }
    //- MARK: - Constraints
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.medium)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            //make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
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
            make.height.equalTo(21)
        }
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordLabel.snp.makeConstraints { make in
            self.passLabelTopToEmailTFBottom = make.top.equalTo(emailTextfield.snp.bottom).offset(13).priority(.high).constraint
            self.errorLabelBottomToPassLabelTop = make.top.equalTo(errorLabel.snp.bottom).offset(16).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(21)
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
        forgotPassButton.snp.makeConstraints { make in
            make.top.equalTo(passTextfield.snp.bottom).offset(7)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        enterButton.snp.makeConstraints { make in
            make.top.equalTo(passTextfield.snp.bottom).offset(79)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        goToSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(enterButton.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(enterButton.snp.bottom).offset(86)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        appleIDSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        googleSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(appleIDSignUpButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(61)
        }
        errorLabel.snp.makeConstraints { make in
            self.errorLabelTopToEmailTFBottom = make.top.equalTo(emailTextfield.snp.bottom).offset(16).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
    }
    func turnOnEmailFormatError() {
        errorLabel.isHidden = false
        errorLabelTopToEmailTFBottom?.update(priority: .high)
        passLabelTopToEmailTFBottom?.update(priority: .low)
        errorLabelBottomToPassLabelTop?.update(priority: .high)
        emailTextfield.layer.borderColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1.0).cgColor
    }
    func turnOffEmailFormatError() {
        errorLabel.isHidden = true
        errorLabelTopToEmailTFBottom?.update(priority: .low)
        passLabelTopToEmailTFBottom?.update(priority: .high)
        errorLabelBottomToPassLabelTop?.update(priority: .low)
        emailTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    //- MARK: - Setup Button Actions
    func setupButtonActions() {
        showPassButton.addTarget(self, action: #selector(showPass), for: .touchUpInside)
        goToSignUpButton.addTarget(self, action: #selector(showSignUpScreen), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        appleIDSignUpButton.addTarget(self, action: #selector(underDev), for: .touchUpInside)
        googleSignUpButton.addTarget(self, action: #selector(underDev), for: .touchUpInside)
        
    }
    @objc func showPass() {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
    }
    @objc func showSignUpScreen() {
        let signupVC = SignUpViewController()
        navigationController?.show(signupVC, sender: self)
    }
    @objc func signInAction() {
        guard let email = emailTextfield.text, !email.isEmpty else { return }
        guard let password = passTextfield.text, !password.isEmpty else { return }
        
        if !emailTextfield.text!.isEmail(){
            showAlertMessage(title: "WRONG_EMAIL".localized(), message: "WRONG_EMAIL_TEXT".localized())
            emailTextfield.text = ""
            turnOffEmailFormatError()
            return
        }
        
            SVProgressHUD.show()
            
            let parameters = ["email": email, "password": password]
            
            AF.request(URLs.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                
                SVProgressHUD.dismiss()
                
                guard let responseCode = response.response?.statusCode else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    return
                }
                if responseCode == 200 {
                    let json = JSON(response.data!)
                    if let token = json["accessToken"].string {
                        AuthenticationService.shared.token = token
                        self.startApp()
                    } else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                } else {
                    var resultString = ""
                    if let data = response.data {
                        resultString = String(data: data, encoding: .utf8)!
                        print(resultString)
                    }
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(sCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            }
    }
    
    @objc func underDev() {
        showAlertMessage(title: "Oops", message: "Not available at the moment")
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
    
    //- MARK: - StartApp
    func startApp() {
        let tabViewController = TabBarController()
        tabViewController.modalPresentationStyle = .fullScreen
        self.present(tabViewController, animated: true, completion: nil)
    }
}
