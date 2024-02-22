//
//  MovieInfoViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 19.02.2024.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SVProgressHUD
import YouTubePlayerKit

class MovieInfoViewController: UIViewController {
    //- MARK: - Variables
    var movie = Movie()
    var similarMovies: [Movie] = []
    var dirLabelTopToDescrLabelBottom: Constraint? = nil
    var dirLabelTopToDescrButtonBottom: Constraint? = nil
    var dirNameLabelTopToDescrLabelBottom: Constraint? = nil
    var dirNameLabelTopToDescrButtonBottom: Constraint? = nil
    var screenLabelTopToSeriesLabelBottom: Constraint? = nil
    var screenLabelTopToLinealViewBottom: Constraint? = nil
    //- MARK: - Top view Outlets
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.contentMode = .scaleToFill
        scrollView.backgroundColor = UIColor.FFFFFF_111827
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    var imageGradientView = CustomGradientView(startColor: UIColor.clear, midColor: UIColor(red: 15/255, green: 22/255, blue: 29/255, alpha: 0.8), endColor: UIColor(red: 15/255, green: 22/255, blue: 29/255, alpha: 0.8), startLocation: 0.5, midLocation: 0.8, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "FavoriteButtonEmpty"), for: .normal)
        return button
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor.D_1_D_5_DB_9_CA_3_AF
        label.text = "Тізімге қосу"
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "ShareIcon"), for: .normal)
        return button
    }()
    
    lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.semiboldFont12
        label.textColor = UIColor.D_1_D_5_DB_9_CA_3_AF
        label.text = "Бөлісу"
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        return button
    }()
    
    //- MARK: - Background View Outletspos
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.FFFFFF_111827
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.mainTitleFont
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font12
        label.textColor = UIColor._9_CA_3_AF
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionText: UILabel = {
        let text = UILabel()
        text.font = appearance.regular400Font14
        text.textColor = UIColor._9_CA_3_AF
        text.numberOfLines = 19
        return text
    }()
    
    var descriptionGradientView = CustomGradientView(startColor: UIColor(named: "startingpoint")!, midColor: UIColor.FFFFFF_111827, endColor: UIColor.FFFFFF_111827, startLocation: 0.01, midLocation: 0.99, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    
    lazy var showFullDescription: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Толығырақ", for: .normal)
        button.setTitleColor(UIColor.purpleLabels, for: .normal)
        button.titleLabel?.font = appearance.semiboldFont14
        return button
    }()
    
    lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.text = "Режиссер:"
        label.font = appearance.regular400Font14
        label.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var producerLabel: UILabel = {
        let label = UILabel()
        label.text = "Продюсер:"
        label.font = appearance.regular400Font14
        label.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.39, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var directorNameLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font14
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var producerNameLabel: UILabel = {
        let label = UILabel()
        label.font = appearance.regular400Font14
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var seriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Бөлімдер"
        label.font = appearance.boldFont16
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var screenshotsLabel: UILabel = {
        let label = UILabel()
        label.text = "Скриншоттар"
        label.font = appearance.boldFont16
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var similarLabel: UILabel = {
        let label = UILabel()
        label.text = "Ұқсас телехикаялар"
        label.font = appearance.boldFont16
        label.textColor = UIColor._111827_FFFFFF
        label.textAlignment = .left
        return label
    }()
    
    lazy var showSeasonButton: UIButton = {
        let button = UIButton()
        button.setTitle("5 сезон, 46 серия", for: .normal)
        button.setTitleColor(UIColor._9_CA_3_AF, for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = appearance.semiboldFont12
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -70)
        return button
    }()
    
    lazy var seasonsButtonArrow: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "arrow")
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var showSimilar: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Барлығы", for: .normal)
        button.titleLabel?.font = appearance.semiboldFont14
        button.titleLabel?.textColor = UIColor.purpleLabels
        return button
    }()
    
    lazy var screenshotCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: "screenCell")
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
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
    
    lazy var similarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SimilarMovieCollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        
        return collectionView
    }()
    
    let linealUpperView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    
    let linealLowerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.D_1_D_5_DB_1_C_2431
        return view
    }()
    
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FFFFFF - 111827")
        navigationItem.title = ""
        downloadSimilar()
        addViews()
        setViews()
        setupConstraints()
        setupButtonActions()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setViews()
        setLines()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //- MARK: - Add & Set Views
    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImage)
        contentView.addSubview(imageGradientView)
        contentView.addSubview(backButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(favoriteLabel)
        contentView.addSubview(shareButton)
        contentView.addSubview(shareLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(backgroundView)
        backgroundView.addSubview(titleNameLabel)
        backgroundView.addSubview(subTitleLabel)
        backgroundView.addSubview(descriptionText)
        backgroundView.addSubview(descriptionGradientView)
        backgroundView.addSubview(showFullDescription)
        backgroundView.addSubview(directorLabel)
        backgroundView.addSubview(directorNameLabel)
        backgroundView.addSubview(producerLabel)
        backgroundView.addSubview(producerNameLabel)
        backgroundView.addSubview(seriesLabel)
        backgroundView.addSubview(showSeasonButton)
        backgroundView.addSubview(seasonsButtonArrow)
        backgroundView.addSubview(screenshotsLabel)
        backgroundView.addSubview(screenshotCollectionView)
        backgroundView.addSubview(similarLabel)
        backgroundView.addSubview(showSimilar)
        backgroundView.addSubview(similarCollectionView)
        backgroundView.addSubview(linealUpperView)
        backgroundView.addSubview(linealLowerView)
        
    }
    func setViews() {
        imageGradientView.updateColors()
        imageGradientView.updateLocations()
        descriptionGradientView.updateColors()
        descriptionGradientView.updateLocations()
        
        if movie.favorite {
            favoriteButton.setImage(UIImage(named: "FavoriteButtonSelected"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteButtonEmpty"), for: .normal)
        }
        
        if movie.movieType == "MOVIE" {
            showSeasonButton.isHidden = true
            seasonsButtonArrow.isHidden = true
            seriesLabel.isHidden = true
            screenLabelTopToSeriesLabelBottom?.update(priority: .low)
            screenLabelTopToLinealViewBottom?.update(priority: .high)
        } else {
            showSeasonButton.setTitle("\(movie.seasonCount)" + " сезон" + "\(movie.seriesCount)" + " серий", for: .normal)
        }
    }
    
    func setLines() {
        if descriptionText.numberOfLines > 4 {
            descriptionText.numberOfLines = 4
        }
        if descriptionText.numberOfVisibleLines < 4 {
            showFullDescription.isHidden = true
            descriptionGradientView.isHidden = true
            dirLabelTopToDescrLabelBottom?.update(priority: .high)
            dirLabelTopToDescrButtonBottom?.update(priority: .low)
            dirNameLabelTopToDescrLabelBottom?.update(priority: .high)
            dirNameLabelTopToDescrButtonBottom?.update(priority: .low)
        } else {
            showFullDescription.isHidden = false
            descriptionGradientView.isHidden = false
        }
    }
    //- MARK: - Set Constraints
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        posterImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(364)
        }
        backButton.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.top.equalToSuperview().inset(35)
            make.leading.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalToSuperview().inset(228)
            make.leading.equalToSuperview().inset(37)
        }
        favoriteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(favoriteButton.snp.centerX)
            make.bottom.equalTo(favoriteButton.snp.bottom).offset(-32)//inset32?
        }
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalToSuperview().inset(228)
            make.trailing.equalToSuperview().inset(37)
        }
        shareLabel.snp.makeConstraints { make in
            make.centerX.equalTo(shareButton.snp.centerX)
            make.bottom.equalTo(shareButton.snp.bottom).offset(-32)//inset32?
        }
        playButton.snp.makeConstraints { make in
            make.size.equalTo(132)
            make.top.equalToSuperview().inset(198)
            make.centerX.equalToSuperview()
        }
        imageGradientView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(364)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(324)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(830)
        }
        titleNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(29)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        linealUpperView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(linealUpperView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.width.equalTo(345)
        }
        showFullDescription.snp.makeConstraints { make in
            make.top.equalTo(descriptionText.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(29)
        }
        directorLabel.snp.makeConstraints { make in
            self.dirLabelTopToDescrButtonBottom =  make.top.equalTo(showFullDescription.snp.bottom).offset(24).priority(.high).constraint
            self.dirLabelTopToDescrLabelBottom =  make.top.equalTo(descriptionText.snp.bottom).offset(24).priority(.low).constraint
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        producerLabel.snp.makeConstraints { make in
            make.top.equalTo(directorLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        directorNameLabel.snp.makeConstraints { make in
            self.dirNameLabelTopToDescrButtonBottom =  make.top.equalTo(showFullDescription.snp.bottom).offset(24).priority(.high).constraint
            self.dirNameLabelTopToDescrLabelBottom =  make.top.equalTo(descriptionText.snp.bottom).offset(24).priority(.low).constraint
            make.leading.equalTo(directorLabel.snp.trailing).offset(19)
            make.height.equalTo(22)
        }
        producerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(directorNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(producerLabel.snp.trailing).offset(16)
            make.height.equalTo(22)
        }
        linealLowerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(producerLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        seriesLabel.snp.makeConstraints { make in
            make.top.equalTo(linealLowerView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(90)
            make.height.equalTo(24)
        }
        showSeasonButton.snp.makeConstraints { make in
            make.leading.equalTo(seriesLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(27)
            make.centerY.equalTo(seriesLabel.snp.centerY)
        }
        seasonsButtonArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(16)
            make.centerY.equalTo(showSeasonButton.snp.centerY)
        }
        screenshotsLabel.snp.makeConstraints { make in
            self.screenLabelTopToSeriesLabelBottom =  make.top.equalTo(seriesLabel.snp.bottom).offset(32).priority(.high).constraint
            self.screenLabelTopToLinealViewBottom =  make.top.equalTo(linealLowerView.snp.bottom).offset(24).priority(.low).constraint
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        screenshotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(screenshotsLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(112)
        }
        similarLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotCollectionView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        showSimilar.snp.makeConstraints { make in
            make.leading.equalTo(similarLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(34)
            make.centerY.equalTo(similarLabel.snp.centerY)
        }
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(220)
        }
        descriptionGradientView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionText.snp.top)
            make.bottom.equalTo(descriptionText.snp.bottom)
        }
    }
    //- MARK: - Set Button Actions
    func setupButtonActions() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playMovie), for: .touchUpInside)
        showFullDescription.addTarget(self, action: #selector(showDescription), for: .touchUpInside)
        showSeasonButton.addTarget(self, action: #selector(showSeason), for: .touchUpInside)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func favoriteAction() {
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        
        let parameters = ["movieId": movie.id] as [String : Any]
        
        AF.request(URLs.FAVORITE_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                
                self.movie.favorite.toggle()
                
                self.setViews()
                
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    @objc func shareAction() {
        let text = "\(movie.name) \n\(movie.description)"
        let image = posterImage.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    @objc func playMovie() {
        if movie.movieType == "MOVIE" {
            let youTubePlayerViewController = YouTubePlayerViewController(player: "")
            youTubePlayerViewController.player.source = .video(id: movie.videoLink, startSeconds: nil, endSeconds: nil)
            youTubePlayerViewController.player.configuration = .init(
                fullscreenMode: .system, autoPlay: true, showControls: true, showFullscreenButton: true, useModestBranding: false, playInline: false, showRelatedVideos: false)
            self.show(youTubePlayerViewController, sender: self)
        } else {
            let seasonsViewController = SeasonSeriesViewController()
            seasonsViewController.movie = movie
            navigationController?.show(seasonsViewController, sender: self)
        }
        
    }
    @objc func showDescription() {
        if descriptionText.numberOfLines > 4 {
            descriptionText.numberOfLines = 4
            showFullDescription.setTitle("Толығырақ", for: .normal)
            descriptionGradientView.isHidden = false
        } else {
            descriptionText.numberOfLines = 30
            showFullDescription.setTitle("Жасыру", for: .normal)
            descriptionGradientView.isHidden = true
        }
    }
    @objc func showSeason() {
        let seasonsViewController = SeasonSeriesViewController()
        seasonsViewController.movie = movie
        navigationController?.show(seasonsViewController, sender: self)
    }
    
    //- MARK: - Set Data
    func setupData() {
        posterImage.sd_setImage(with: URL(string: movie.posterLink), completed: nil)
        titleNameLabel.text = movie.name
        subTitleLabel.text = "\(movie.year)"
        for i in movie.genres {
            subTitleLabel.text = subTitleLabel.text! + " • " + i.name
        }
        descriptionText.text = movie.description
        directorNameLabel.text = movie.director
        producerNameLabel.text = movie.producer
    }
    //- MARK: - Download similar movies
    func downloadSimilar() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        
        AF.request(URLs.GET_SIMILAR + String(movie.id), method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let movie = Movie(json: item)
                        self.similarMovies.append(movie)
                    }
                    self.similarCollectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
}

//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension MovieInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.similarCollectionView {
            return similarMovies.count
        }
        return movie.screenshots.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarMovieCollectionViewCell
            let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
            cell.posterImage.sd_setImage(with: URL(string: similarMovies[indexPath.item].posterLink), placeholderImage: nil, context: [.imageTransformer: transformer])
            cell.title.text = similarMovies[indexPath.item].name
            
            if let genrename = similarMovies[indexPath.item].genres.first {
                cell.subTitle.text = genrename.name
            } else {
                cell.subTitle.text = ""
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath) as! ScreenshotCollectionViewCell
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        cell.posterImage.sd_setImage(with: URL(string: movie.screenshots[indexPath.item].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.similarCollectionView {
            let movieinfoVC = MovieInfoViewController()
            movieinfoVC.movie = similarMovies[indexPath.row]
            navigationController?.show(movieinfoVC, sender: self)
        }
        let screenVC = ScreenshotViewController()
        screenVC.selectedScreenshotIndex = indexPath.item
        screenVC.movie = movie
        navigationController?.show(screenVC, sender: self)
    }
}
