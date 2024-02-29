//
//  LanguageViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 23.02.2024.
//

import UIKit
import SnapKit
import Localize_Swift

class LanguageViewController: UIViewController, UIGestureRecognizerDelegate {
    //- MARK: - Variables
    let languageArray = [["English", "en"], ["Қазақша", "kk"], ["Русский", "ru"]]
    weak var delegate: Language?
    //- MARK: - Outlets
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "LANGUAGE".localized()
        label.font = appearance.mainTitleFont
        label.textColor = UIColor._111827_FFFFFF
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LanguageTableViewCell.self, forCellReuseIdentifier: "languageCell")
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        addViews()
        setupView()
        setupConstraints()
    }
    
    func addViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(lineView)
        backgroundView.addSubview(topLabel)
        backgroundView.addSubview(tableView)
    }
    func setupView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
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
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(14)
            make.leading.trailing.bottom.equalToSuperview()
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
}

//- MARK: - UITableViewDelegate & UITableViewDataSource
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguageTableViewCell
        cell.label.text = languageArray[indexPath.row][0]
        if Localize.currentLanguage() == languageArray[indexPath.row][1] {
            cell.checkImage.image = UIImage(named: "Check")
        } else {
            cell.checkImage.image = nil
        }
        if cell.label.text == "Русский" {
            cell.dividerView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Localize.setCurrentLanguage(languageArray[indexPath.row][1])
        delegate?.languageDidChange()
        dismiss(animated: true, completion: nil)
    }
}

//- MARK: - Cell
private class LanguageTableViewCell: UITableViewCell {
    //- MARK: - Local outlets
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont16
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()
    lazy var checkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Check")
        return image
    }()
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "languageCell")
        self.backgroundColor = UIColor.FFFFFF_1_C_2431
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //- MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(label)
        contentView.addSubview(checkImage)
        contentView.addSubview(dividerView)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        checkImage.snp.makeConstraints { make in
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
