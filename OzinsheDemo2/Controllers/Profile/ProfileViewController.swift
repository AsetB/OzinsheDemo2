//
//  ProfileViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit
import SnapKit
import Localize_Swift
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    //- MARK: - Outlets
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Avatar")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var profileTopLabel: UILabel = {
        let label = UILabel()
        label.text = "Менің профилім"
        label.font = appearance.mainTitleFont
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.F_9_FAFB_111827
        return view
    }()
    
    private lazy var personalDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Жеке деректер", for: .normal)
        button.setTitleColor(UIColor._1_C_2431_E_5_E_7_EB, for: .normal)
        button.titleLabel?.font = appearance.medium500Font16
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(editPersonalData), for: .touchUpInside)
        
        var image = UIImageView()
        image.image = UIImage(named: "arrow")
        button.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(16)
        }
        
        return button
    }()
    
    private lazy var editLabel: UILabel = {
        var label = UILabel()
        label.text = "EDIT".localized()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    private lazy var changePassButton: UIButton = {
        let button = UIButton()
        button.setTitle("Құпия сөзді өзгерту", for: .normal)
        button.setTitleColor(UIColor._1_C_2431_E_5_E_7_EB, for: .normal)
        button.titleLabel?.font = appearance.medium500Font16
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(changePass), for: .touchUpInside)
        var image = UIImageView()
        image.image = UIImage(named: "arrow")
        button.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(16)
        }
        return button
    }()

    private lazy var changeLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("LANGUAGE".localized(), for: .normal)
        button.setTitleColor(UIColor._1_C_2431_E_5_E_7_EB, for: .normal)
        button.titleLabel?.font = appearance.medium500Font16
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        var image = UIImageView()
        image.image = UIImage(named: "arrow")
        button.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(16)
        }
        return button
    }()
    
    private lazy var currentLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "Қазақша"
        label.font = appearance.semiboldFont12
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
  
    private lazy var darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Қараңғы режим"
        label.font = appearance.medium500Font16
        label.textColor = UIColor._1_C_2431_E_5_E_7_EB
        return label
    }()
    
    private lazy var darkModeSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = UIColor(red: 179/255, green: 118/255, blue: 247/255, alpha: 1)
        switchButton.backgroundColor = UIColor.F_9_FAFB_111827
        switchButton.addTarget(self, action: #selector(changeTheme), for: .valueChanged)
        return switchButton
    }()
    //dividers
    private let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    
    private let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    
    private let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_1_C_2431
        navigationItem.title = "PROFILE".localized()
        addViews()
        setupViews()
        setupConstraints()
        setLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadProfileInfo()
        setLanguage()
        setupViews()
    }
    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(profileImage)
        view.addSubview(profileTopLabel)
        view.addSubview(emailLabel)
        view.addSubview(backgroundView)
        backgroundView.addSubview(personalDataButton)
        personalDataButton.addSubview(editLabel)
        backgroundView.addSubview(dividerView1)
        backgroundView.addSubview(changePassButton)
        backgroundView.addSubview(dividerView2)
        backgroundView.addSubview(changeLanguageButton)
        changeLanguageButton.addSubview(currentLanguageLabel)
        backgroundView.addSubview(dividerView3)
        backgroundView.addSubview(darkModeLabel)
        backgroundView.addSubview(darkModeSwitch)
    }
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Logout"), style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 0.25, blue: 0.17, alpha: 1)
        
        if UserDefaults.standard.string(forKey: "Theme") == "Dark" {
            darkModeSwitch.setOn(true, animated: false)
        } else {
            darkModeSwitch.setOn(false, animated: false)
        }
    }
    //- MARK: - Constraints
    private func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(104)
        }
        profileTopLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(32)
            make.centerX.equalTo(profileImage)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(profileTopLabel.snp.bottom).offset(8)
            make.centerX.equalTo(profileTopLabel)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        personalDataButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        editLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(16)
        }
        dividerView1.snp.makeConstraints { make in
            make.top.equalTo(personalDataButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        changePassButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView1.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        dividerView2.snp.makeConstraints { make in
            make.top.equalTo(changePassButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        changeLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(dividerView2.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        currentLanguageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        dividerView3.snp.makeConstraints { make in
            make.top.equalTo(changeLanguageButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        darkModeLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView3.snp.bottom).offset(25)
            make.leading.equalTo(changeLanguageButton.snp.leading)
            //make.leading.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        darkModeSwitch.snp.makeConstraints { make in
            make.top.equalTo(dividerView3.snp.bottom).offset(20)
            make.trailing.equalTo(changeLanguageButton.snp.trailing)
            make.width.equalTo(52)
            make.height.equalTo(32)
        }
    }
    //- MARK: - Button actions
    @objc func signOut() {
        let signOutView = ProfileLogoutViewController()
        signOutView.modalPresentationStyle = .overFullScreen
        present(signOutView, animated: true, completion: nil)
    }
    @objc func editPersonalData() {
        let editView = ProfileEditViewController()
        navigationController?.show(editView, sender: self)
    }
    @objc func changePass() {
        let passChangeView = PassChangeViewController()
        navigationController?.show(passChangeView, sender: self)
    }
    @objc func changeLanguage() {
        let languageView = LanguageViewController()
        languageView.modalPresentationStyle = .overFullScreen
        languageView.delegate = self
        
        present(languageView, animated: true, completion: nil)
    }
    @objc private func changeTheme() {
        let defaults = UserDefaults.standard
        if let window = view.window {
            if darkModeSwitch.isOn {
                window.overrideUserInterfaceStyle = .dark
                defaults.set("Dark", forKey: "Theme")
            } else {
                window.overrideUserInterfaceStyle = .light
                defaults.set("Light", forKey: "Theme")
            }
        }
    }
    //- MARK: - Data load
    private func loadProfileInfo() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_PROFILE_URL, method: .get, headers: headers).responseData { [weak self] response in
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let name = json["name"].string {
                    UserDefaults.standard.set(name, forKey: "name")
                } else {
                    print("Error doesnt load name")
                }
                if let birthDate = json["birthDate"].string {
                    UserDefaults.standard.set(birthDate, forKey: "birthDate")
                } else {
                    print("Error doesnt load birthDate")
                }
                if let phoneNumber = json["phoneNumber"].string {
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                } else {
                    print("Error doesnt load phoneNumber")
                }
                if let userData = json["user"].dictionary {
                    let user = User(dictionary: userData)
                    Storage.sharedInstance.userData = user
                    if let email = userData["email"]?.string {
                        Storage.sharedInstance.userData?.email = email
                        UserDefaults.standard.set(email, forKey: "email")
                    }
                    if let userId = userData["id"]?.int {
                        Storage.sharedInstance.userData?.id = userId
                        UserDefaults.standard.set(userId, forKey: "userId")
                    }
                } else {
                    print("Error doesnt load user")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                print(ErrorString)
            }
            self?.emailLabel.text = UserDefaults.standard.string(forKey: "email")
        }
    }
}

extension ProfileViewController: Language {
    func languageDidChange() {
        setLanguage()
    }
    
    private func setLanguage() {
        switch Localize.currentLanguage() {
        case "ru": currentLanguageLabel.text = "Русский"
        case "en": currentLanguageLabel.text = "English"
        case "kk": currentLanguageLabel.text = "Қазақша"
        default: currentLanguageLabel.text = "Қазақша"
        }
        
        changeLanguageButton.setTitle("LANGUAGE".localized(), for: .normal)
        profileTopLabel.text = "MY_PROFILE".localized()
        personalDataButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        changePassButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        darkModeLabel.text = "DARK_MODE".localized()
        editLabel.text = "EDIT".localized()
        navigationItem.title = "PROFILE".localized()
    }
}
