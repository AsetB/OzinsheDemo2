//
//  SearchCollectionViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 22.02.2024.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var categoryView = {
        let view = UIView()
        let label = UILabel()
        view.backgroundColor = UIColor.F_3_F_4_F_6_374151
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor._374151_F_9_FAFB
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
        contentView.addSubview(categoryView)
        categoryView.addSubview(categoryNameLabel)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        categoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(34)
        }
        categoryNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalTo(categoryView.snp.centerY)
        }
    }
}
