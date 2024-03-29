//
//  SlidesCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit
import SnapKit
import Localize_Swift

class SlidesCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    let slideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let centerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = UIColor(named: "111827 - FFFFFF")
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let centerText: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "SFProDisplay-Medium", size: 14)
        text.textColor = UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 0.9)
        text.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: text.text ?? "default value")
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        text.attributedText = attributedString
        
        return text
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        let title: String = "SKIP".localized()
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 12)!]))
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
        config.background.cornerRadius = 8
        config.baseBackgroundColor = UIColor(named: "FFFFFF - 111827")
        config.baseForegroundColor = UIColor(named: "111827 - FFFFFF")
        button.configuration = config
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "PurpleButtons")
        button.layer.cornerRadius = 12
        button.setTitle("NEXT".localized(), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        button.titleLabel?.textColor = UIColor(named: "FFFFFF")
        return button
    }()
    
    //- MARK: - Gradient
    var gradientView = CustomGradientView(startColor: UIColor(named: "startingpoint")!, midColor: UIColor(named: "endingpoint")!, endColor: UIColor(named: "endingpoint")!, startLocation: 0.01, midLocation: 0.37, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    
    //- MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "FFFFFF - 111827")
        setupViews()
        setupConstraints()
        gradientView.updateColors()
        gradientView.updateLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //- MARK: - Constraints
    func setupConstraints() {
        slideImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(274)
        }
        centerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(dynamicValue(for: 276))
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        centerText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.top.equalTo(centerLabel.snp.bottom).offset(24)
        }
        skipButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
        }
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(38)
            make.height.equalTo(56)
        }
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(dynamicValue(for: 180))
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    //- MARK: - Views
    func setupViews() {
        contentView.addSubview(slideImage)
        contentView.addSubview(gradientView)
        contentView.addSubview(centerLabel)
        contentView.addSubview(centerText)
        contentView.addSubview(skipButton)
        contentView.addSubview(nextButton)
    }
    //- MARK: - Setup Cell
    func setupCell(slides: Slides) {
        slideImage.image = UIImage(named: "\(slides.image)")
        centerLabel.text = slides.centerLabel
        centerText.text = slides.textLabel
    }
}
