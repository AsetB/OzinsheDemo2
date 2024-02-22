//
//  MovieTableViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 22.02.2024.
//

import UIKit
import SnapKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    //- MARK: - Local Outlets
    lazy var posterImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()

    lazy var titleLabel = {
        let label = UILabel()
        label.font = appearance.boldFont14
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()

    lazy var subTitleLabel = {
        let label = UILabel()
        label.font = appearance.regular400Font12
        label.textColor = UIColor._9_CA_3_AF
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    lazy var playView = {
        let view = UIView()
        let imageView = UIImageView()
        let label = UILabel()

        view.addSubview(imageView)
        view.addSubview(label)

        view.backgroundColor = UIColor.F_8_EEFF_1_C_2431
        view.layer.cornerRadius = 8

        imageView.image = UIImage(named: "Play")

        label.text = "Қарау"
        label.textColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1)
        label.font =  appearance.boldFont12

        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(5)
            make.size.equalTo(16)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.equalToSuperview().inset(12)
        }

        return view
    }()
    
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "movieCell")
        self.backgroundColor = UIColor.FFFFFF_111827
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //- MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(playView)
    }
    //- MARK: - Constarints
    func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(71)
            make.height.equalTo(104)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(posterImageView.snp.trailing).offset(17)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(titleLabel)
        }
        playView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(subTitleLabel)
        }
    }
    //- MARK: - Constarints
    func setCellData(movie: Movie) {
        posterImageView.sd_setImage(with: URL(string: movie.posterLink), completed: nil)
        titleLabel.text = movie.name
        subTitleLabel.text = "\(movie.year)"
        for item in movie.genres {
            subTitleLabel.text = subTitleLabel.text! + " • " + item.name
        }
    }
}
