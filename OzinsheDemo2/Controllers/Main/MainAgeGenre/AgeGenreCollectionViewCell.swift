//
//  AgeGenreCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit

class AgeGenreCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = appearance.imagesCornerRadius
        image.clipsToBounds = true
        return image
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont14
        label.textColor = UIColor.FFFFFF
        label.textAlignment = .center
        return label
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
        posterImage.addSubview(title)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(184)
            make.height.equalTo(112)
        }
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
