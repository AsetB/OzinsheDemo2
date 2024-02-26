//
//  PassChangeViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 24.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class PassChangeViewController: UIViewController {
    //- MARK: - Outlets
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөз"
        label.font = appearance.boldFont14
        label.textColor = appearance.c111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    private lazy var repeatPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөзді қайталаңыз"
        label.font = appearance.boldFont14
        label.textColor = appearance.c111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    private lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "YOUR_PASSWORD".localized()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
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
        textfield.backgroundColor = UIColor.FFFFFF_1_C_2431
        return textfield
    }()
    
    private lazy var repeatPassTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "YOUR_PASSWORD".localized()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.regular400Font16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
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
        textfield.backgroundColor = UIColor.FFFFFF_1_C_2431
        return textfield
    }()
    
    private lazy var showPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Show")
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 18, trailing: 16)
        button.configuration = config
        button.addTarget(self, action: #selector(showPass), for: .touchUpInside)
        return button
    }()
    
    private lazy var showRepeatPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Show")
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 18, trailing: 16)
        button.configuration = config
        button.addTarget(self, action: #selector(showRepeatPass), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "PurpleButtons")
        button.layer.cornerRadius = 12
        button.setTitle("Өзгерістерді сақтау", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.titleLabel?.textColor = UIColor(named: "FFFFFF")
        button.addTarget(self, action: #selector(saveNewPass), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.FFFFFF_111827
        navigationItem.title = "Құпия сөзді өзгерту"
        setupView()
        setupConstraints()
        setupBorderColor()
        hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        localize()
    }
    //- MARK: - Setup View
    private func setupView() {
        view.addSubview(passwordLabel)
        view.addSubview(passTextfield)
        view.addSubview(showPassButton)
        view.addSubview(repeatPasswordLabel)
        view.addSubview(repeatPassTextfield)
        view.addSubview(showRepeatPassButton)
        view.addSubview(saveButton)
    }
    //- MARK: - Constraints
    private func setupConstraints() {
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(21)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        passTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
        }
        showPassButton.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(56)
            make.trailing.equalTo(passTextfield.snp.trailing)
            make.centerY.equalTo(passTextfield.snp.centerY)
        }
        repeatPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passTextfield.snp.bottom).offset(21)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        repeatPassTextfield.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
        }
        showRepeatPassButton.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(56)
            make.trailing.equalTo(repeatPassTextfield.snp.trailing)
            make.centerY.equalTo(repeatPassTextfield.snp.centerY)
        }
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(42)
        }
    }
    //- MARK: - Dark mode(for CGColor)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupBorderColor()
    }
    
    func setupBorderColor(){
        passTextfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
        repeatPassTextfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
    }
    //- MARK: - Textfield actions
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
    //- MARK: - Button actions
    @objc func showPass() {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
    }
    @objc func showRepeatPass() {
        repeatPassTextfield.isSecureTextEntry = !repeatPassTextfield.isSecureTextEntry
    }
    @objc func saveNewPass() {
        guard let password = passTextfield.text, !password.isEmpty else { return }
        guard let repeatedPass = repeatPassTextfield.text, !repeatedPass.isEmpty else { return }
       
        if password == repeatedPass {
            
            SVProgressHUD.show()
            let parameters = ["password": password]
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            
            AF.request(URLs.CHANGE_PASS_URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    if let token = json["accessToken"].string {
                        AuthenticationService.shared.token = token
                        SVProgressHUD.showSuccess(withStatus: "PASS_CHANGED".localized())
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
    
    //- MARK: - Localization
    private func localize() {
        navigationItem.title = "CHANGE_PASSWORD".localized()
        passwordLabel.text = "PASSWORD".localized()
        repeatPasswordLabel.text = "REPEAT_PASSWORD".localized()
        saveButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
    }
}
