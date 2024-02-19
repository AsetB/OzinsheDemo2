//
//  MainBannerCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit
import SDWebImage

class MainBannerCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    lazy var bannerCategoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .purpleBack
        view.layer.cornerRadius = appearance.capsuleCornerRadius
        return view
    }()
    
    lazy var bannerCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.medium500Font12
        label.textColor = UIColor.FFFFFF
        return label
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = appearance.boldFont14
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font12
        label.textColor = UIColor._9_CA_3_AF
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
        contentView.addSubview(bannerCategoryView)
        bannerCategoryView.addSubview(bannerCategoryLabel)
        contentView.addSubview(title)
        contentView.addSubview(descriptionLabel)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(164)
        }
        bannerCategoryView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        bannerCategoryLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    //- MARK: - Setup Cell Data
    func setCellData(bannerMovie: BannerMovie) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 164), scaleMode: .aspectFill)
        posterImage.sd_setImage(with: URL(string: bannerMovie.link), placeholderImage: nil, context: [.imageTransformer : transformer])
        if let categoryName = bannerMovie.movie.categories.first?.name {
            bannerCategoryLabel.text = categoryName
        }
        title.text = bannerMovie.movie.name
        descriptionLabel.text = bannerMovie.movie.description
    }
}

