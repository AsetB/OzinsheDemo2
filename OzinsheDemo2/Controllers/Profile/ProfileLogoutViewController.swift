//
//  ProfileLogoutViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 24.02.2024.
//

import UIKit
import SnapKit

class ProfileLogoutViewController: UIViewController, UIGestureRecognizerDelegate {
    //- MARK: - Outlets
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Шығу"
        label.font = appearance.mainTitleFont
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сіз шынымен аккаунтыныздан "
        label.font = appearance.regular400Font14
        label.textColor = UIColor._9_CA_3_AF
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_6_B_7280
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.FFFFFF_1_C_2431
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "PurpleButtons")
        button.layer.cornerRadius = 12
        button.setTitle("Иә, шығу", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.titleLabel?.textColor = UIColor(named: "FFFFFF")
        button.addTarget(self, action: #selector(userDidLogout), for: .touchUpInside)
        return button
    }()
    
    lazy var noConfirmButton: UIButton = {
        let button = UIButton()
        //button.backgroundColor = UIColor.transparent
        button.setTitle("Жоқ", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.setTitleColor(UIColor.purpleNoButton, for: .normal)
        button.addTarget(self, action: #selector(cancelLogout), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        addViews()
        setupView()
        setupConstraints()
    }
    //- MARK: - Setup Views
    func addViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(lineView)
        backgroundView.addSubview(topLabel)
        backgroundView.addSubview(subTitleLabel)
        backgroundView.addSubview(confirmButton)
        backgroundView.addSubview(noConfirmButton)
    }
    func setupView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.height.equalTo(303)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.centerX.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(5)
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(58)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(topLabel.snp.horizontalEdges)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        noConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(confirmButton.snp.horizontalEdges)
            make.height.equalTo(56)
        }
    }
    //- MARK: - Gesture
    @objc func dismissView() {
      self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if (touch.view?.isDescendant(of: backgroundView))! {
        return false
      }
      return true
    }
    //- MARK: - Button actions
    @objc func userDidLogout() {
        AuthenticationService.shared.tokenClear()
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "birthDate")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        
        let rootViewController = UINavigationController(rootViewController: SignInViewController())
        
        let sceneDelegate = UIApplication.shared.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = rootViewController
        sceneDelegate.window?.makeKeyAndVisible()
    }
    @objc func cancelLogout() {
        dismissView()
    }
}
