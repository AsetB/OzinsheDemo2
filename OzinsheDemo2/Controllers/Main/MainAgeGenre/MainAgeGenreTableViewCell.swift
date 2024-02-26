//
//  MainAgeGenreTableViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit
import SDWebImage
import Localize_Swift

class MainAgeGenreTableViewCell: UITableViewCell {
    //- MARK: - Variables
    var mainMovies = MainMovies()
    weak var delegate: ItemDidSelect?
    
    //- MARK: - Local Outlets
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.boldFont16
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AgeGenreCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        //layout.itemSize = CGSize(width: 112, height: 220)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 184
        layout.estimatedItemSize.height = 112
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        
        return collectionView
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "mainAgeGenreCell")
        self.backgroundColor = UIColor.FFFFFF_111827
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //- MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(collectionView)
    }
    //- MARK: - Constarints
    func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    //- MARK: - Setup Cell Data
    func setCellData(mainMovie: MainMovies) {
        self.mainMovies = mainMovie
        if mainMovie.cellType == .ageCategory {
            mainLabel.text = "AGE_CATEGORY".localized()
        } else {
            mainLabel.text = "CHOOSE_GENRE".localized()
        }
        collectionView.reloadData()
    }
}

//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension MainAgeGenreTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mainMovies.cellType == .ageCategory {
            return mainMovies.categoryAges.count
        }
        return mainMovies.genres.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AgeGenreCollectionViewCell
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        if mainMovies.cellType == .ageCategory {
            cell.posterImage.sd_setImage(with: URL(string: mainMovies.categoryAges[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer : transformer])
            
            cell.title.text = mainMovies.categoryAges[indexPath.row].name
        } else {
            cell.posterImage.sd_setImage(with: URL(string: mainMovies.genres[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer : transformer])
            
            cell.title.text = mainMovies.genres[indexPath.row].name
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if mainMovies.cellType == .ageCategory {
            delegate?.ageDidSelect(ageID: mainMovies.categoryAges[indexPath.row].id, ageName: mainMovies.categoryAges[indexPath.row].name)
        } else {
            delegate?.genreDidSelect(genreID: mainMovies.genres[indexPath.row].id, genreName: mainMovies.genres[indexPath.row].name)
        }
    }
}
