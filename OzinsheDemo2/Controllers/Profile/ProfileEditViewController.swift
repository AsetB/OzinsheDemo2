//
//  ProfileEditViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 23.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import Localize_Swift
import SVProgressHUD

class ProfileEditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    //- MARK: - Outlets
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Сіздің атыңыз"
        label.font = appearance.boldFont14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = appearance.boldFont14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон"
        label.font = appearance.boldFont14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Туылған күні"
        label.font = appearance.boldFont14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "PurpleButtons")
        button.layer.cornerRadius = 12
        button.setTitle("Өзгерістерді сақтау", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.titleLabel?.textColor = UIColor(named: "FFFFFF")
        button.addTarget(self, action: #selector(savePersonalData), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.medium500Font16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.addTarget(self,
                            action: #selector(nameTextfieldEditingChange),
                            for: .editingChanged)
        textfield.backgroundColor = UIColor.FFFFFF_111827
        textfield.borderStyle = .none
        textfield.textContentType = .givenName
        return textfield
    }()
    
    lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.medium500Font16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.addTarget(self,
                            action: #selector(nameTextfieldEditingChange),
                            for: .editingChanged)
        textfield.backgroundColor = UIColor.FFFFFF_111827
        textfield.borderStyle = .none
        textfield.autocapitalizationType = .none
        textfield.textContentType = .emailAddress
        textfield.keyboardType = .emailAddress
        return textfield
    }()
    
    lazy var phoneTextfield: UITextField = {
        let textfield = UITextField()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.medium500Font16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.addTarget(self,
                            action: #selector(nameTextfieldEditingChange),
                            for: .editingChanged)
        textfield.backgroundColor = UIColor.FFFFFF_111827
        textfield.borderStyle = .none
        textfield.textContentType = .telephoneNumber
        textfield.keyboardType = .phonePad
        textfield.delegate = self
        return textfield
    }()
    
    lazy var birthdayTextfield: UITextField = {
        let textfield = UITextField()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.medium500Font16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.addTarget(self,
                            action: #selector(nameTextfieldEditingChange),
                            for: .editingChanged)
        textfield.backgroundColor = UIColor.FFFFFF_111827
        textfield.borderStyle = .none
        textfield.delegate = self
        textfield.inputView = datePicker
        return textfield
    }()
    
    //MARK: Date Picker
    private lazy var datePicker = {
        let datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        return datePicker
    }()
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdayTextfield.text = dateFormatter.string(from: sender.date)
        }
    
    //MARK: Dividers
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    let dividerView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        navigationItem.title = "Жеке деректер"
        addViews()
        setupView()
        setupConstraints()
        hideKeyboardWhenTappedAround()
    }
    //- MARK: - Add & Setup Views
    func addViews() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextfield)
        view.addSubview(dividerView1)
        view.addSubview(emailLabel)
        view.addSubview(emailTextfield)
        view.addSubview(dividerView2)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextfield)
        view.addSubview(dividerView3)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextfield)
        view.addSubview(dividerView4)
        view.addSubview(saveButton)
    }
    func setupView() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        nameTextfield.text = UserDefaults.standard.string(forKey: "name")
        emailTextfield.text = UserDefaults.standard.string(forKey: "email")
        phoneTextfield.text = UserDefaults.standard.string(forKey: "phoneNumber")
        birthdayTextfield.text = UserDefaults.standard.string(forKey: "birthDate")
    }
    //- MARK: - Constraints
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        nameTextfield.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(47)
        }
        dividerView1.snp.makeConstraints { make in
            make.top.equalTo(nameTextfield.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameTextfield.snp.horizontalEdges)
            make.height.equalTo(1)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView1.snp.bottom).offset(8)
            make.leading.equalTo(dividerView1.snp.leading)
        }
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(dividerView1.snp.horizontalEdges)
            make.height.equalTo(47)
        }
        dividerView2.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(emailTextfield.snp.horizontalEdges)
            make.height.equalTo(1)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView2.snp.bottom).offset(8)
            make.leading.equalTo(dividerView2.snp.leading)
        }
        phoneTextfield.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(dividerView2.snp.horizontalEdges)
            make.height.equalTo(47)
        }
        dividerView3.snp.makeConstraints { make in
            make.top.equalTo(phoneTextfield.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(phoneTextfield.snp.horizontalEdges)
            make.height.equalTo(1)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView3.snp.bottom).offset(8)
            make.leading.equalTo(dividerView3.snp.leading)
        }
        birthdayTextfield.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(dividerView3.snp.horizontalEdges)
            make.height.equalTo(47)
        }
        dividerView4.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextfield.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(birthdayTextfield.snp.horizontalEdges)
            make.height.equalTo(1)
        }
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(42)
        }
    }
    //- MARK: - Actions
    @objc func nameTextfieldEditingChange() {
        
    }
    @objc func savePersonalData() {
        guard let birthDate = birthdayTextfield.text else { return }
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let language = "English"
        guard let name = nameTextfield.text else { return }
        guard let phoneNumber = phoneTextfield.text else { return }
        
        if birthDate.isEmpty || name.isEmpty || phoneNumber.isEmpty { return }
        
        SVProgressHUD.show()
        let parameters = ["birthDate": birthDate, "id": userId, "language": language, "name": name, "phoneNumber": phoneNumber] as [String : Any]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.UPDATE_PROFILE_URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
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
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
        SVProgressHUD.showSuccess(withStatus: "Profile data saved")
        setupView()
    }
}
