//
//  SeasonCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 21.02.2024.
//

import UIKit
import SnapKit

class SeasonCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var seasonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = appearance.capsuleCornerRadius
        view.backgroundColor = appearance.F3F4F6_374151
        return view
    }()
    
    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor._374151_F_9_FAFB
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
        contentView.addSubview(seasonView)
        seasonView.addSubview(seasonLabel)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        seasonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(34)
        }
        seasonLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }
    //- MARK: - Setup Cell Data
    func setCellData(mainMovie: MainMovies) {
        
    }
}
