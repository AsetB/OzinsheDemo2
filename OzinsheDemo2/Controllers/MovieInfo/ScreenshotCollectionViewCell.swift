//
//  ScreenshotCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = appearance.imagesCornerRadius
        image.clipsToBounds = true
        return image
    }()
    //- MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.FFFFFF_111827
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //- MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(posterImage)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(184)
            make.height.equalTo(112)
        }
        
    }
}
