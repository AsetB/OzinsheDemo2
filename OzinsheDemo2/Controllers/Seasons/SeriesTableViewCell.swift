//
//  SeriesTableViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 21.02.2024.
//

import UIKit
import SnapKit

class SeriesTableViewCell: UITableViewCell {
    //- MARK: - Local Outlets
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    lazy var seriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = ._111827_FFFFFF
        label.font = appearance.boldFont14
        label.textAlignment = .left
        return label
    }()
    
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "seriesCell")
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
        contentView.addSubview(seriesLabel)
    }
    
    //- MARK: - Constarints
    func setupConstraints() {
        posterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(178)
        }
        seriesLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    //- MARK: - Setup Cell Data
    func setCellData(mainMovie: MainMovies) {
       
    }

}
