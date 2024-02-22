//
//  ScreenshotViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 22.02.2024.
//

import UIKit
import SnapKit
import SDWebImage

class ScreenshotViewController: UIViewController {
    //- MARK: - Variables
    var movie = Movie()
    var selectedScreenshotIndex: Int?
    //- MARK: - Outlets
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScreenCollectionViewCell.self, forCellWithReuseIdentifier: "screenCell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize.width = UIScreen.main.bounds.width
        layout.itemSize.height = UIScreen.main.bounds.height
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        
        
        
        return collectionView
    }()
   
    //- MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        setView()
    }
    
    func setView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        if let index = selectedScreenshotIndex {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            guard let rect = self.collectionView.layoutAttributesForItem(at: indexPath)?.frame else { return }
            self.collectionView.scrollRectToVisible(rect, animated: false)
        }
    }
}

//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ScreenshotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movie.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath) as! ScreenCollectionViewCell
        cell.image.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link), placeholderImage: nil)
        cell.image.enableZoom()
        cell.image.enableDoubleTapZoom()
   
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//- MARK: - ScreenCollectionViewCell
private class ScreenCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
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
        contentView.addSubview(image)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
