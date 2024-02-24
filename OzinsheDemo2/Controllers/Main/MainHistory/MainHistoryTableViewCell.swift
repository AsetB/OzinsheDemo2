//
//  MainHistoryTableViewCell.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit
import SDWebImage

class MainHistoryTableViewCell: UITableViewCell {
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
        collectionView.register(MainHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 184
        layout.estimatedItemSize.height = 156
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        
        return collectionView
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "mainHistoryCell")
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
            make.leading.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    //- MARK: - Setup Cell Data
    func setCellData(mainMovie: MainMovies) {
        mainLabel.text = "Қарауды жалғастырыңыз"
        self.mainMovies = mainMovie
        collectionView.reloadData()
    }
}

//- MARK: - ICollectionViewDelegate & UICollectionViewDataSource
extension MainHistoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainMovies.movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainHistoryCollectionViewCell
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        cell.posterImage.sd_setImage(with: URL(string: mainMovies.movies[indexPath.row].posterLink), placeholderImage: nil, context: [.imageTransformer : transformer])
        
        cell.title.text = mainMovies.movies[indexPath.row].name
        
        if let genreName = mainMovies.movies[indexPath.row].genres.first {
            cell.subTitle.text = genreName.name
        } else {
            cell.subTitle.text = ""
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.movieDidSelect(movie: mainMovies.movies[indexPath.row])
    }
}
