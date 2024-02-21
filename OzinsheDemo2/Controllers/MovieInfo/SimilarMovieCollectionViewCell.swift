//
//  SimilarMovieCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit

class SimilarMovieCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = appearance.imagesCornerRadius
        image.clipsToBounds = true
        return image
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font12
        label.textColor = UIColor._9_CA_3_AF
        label.textAlignment = .left
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
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(112)
            make.height.equalTo(164)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    //- MARK: - Setup Cell Data
    func setCellData(mainMovie: MainMovies) {
        
    }
}
