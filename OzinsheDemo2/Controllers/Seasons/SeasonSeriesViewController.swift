//
//  SeasonSeriesViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 21.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD
import YouTubePlayerKit
import Localize_Swift

class SeasonSeriesViewController: UIViewController {
    //- MARK: - Variables
    var movie = Movie()
    var seasons: [Season] = []
    var currentSeason = 0
    //- MARK: - Local Outlets
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SeasonCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 8, right: 24)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize.width = 128
        layout.estimatedItemSize.height = 34
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        
        return collectionView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        downloadSeason()
        setupViews()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "SECTIONS".localized()
    }
    //- MARK: - Setup View
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    //- MARK: - Setup Constraints
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(74)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //- MARK: - Download Season
    func downloadSeason() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_SEASONS + String(movie.id), method: .get, headers: headers).responseData { response in
    
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
                        let season = Season(json: item)
                        self.seasons.append(season)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
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
extension SeasonSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SeasonCollectionViewCell
        
        cell.seasonLabel.text = "\(seasons[indexPath.row].number)" + "SEASON_IN_SERIES".localized()
        
        if currentSeason == seasons[indexPath.row].number - 1 {
            cell.seasonLabel.textColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
            cell.seasonView.backgroundColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1)
        } else {
            cell.seasonLabel.textColor = UIColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
            cell.seasonView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentSeason = seasons[indexPath.row].number - 1
        tableView.reloadData()
        collectionView.reloadData()
    }
}

//- MARK: - UITableViewDelegate & UITableViewDataSource
extension SeasonSeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seasons.isEmpty {
            return 0
        }
        return seasons[currentSeason].videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SeriesTableViewCell()
        cell.seriesLabel.text = "\(seasons[currentSeason].videos[indexPath.row].number)" + "EPISODE".localized()
        let transformer = SDImageResizingTransformer(size: CGSize(width: 345, height: 178), scaleMode: .aspectFill)
        cell.posterImage.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(seasons[currentSeason].videos[indexPath.row].link)/hqdefault.jpg"), placeholderImage: nil, context: [.imageTransformer : transformer])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let youTubePlayerViewController = YouTubePlayerViewController(
            player: ""
        )
        youTubePlayerViewController.player.source = .video(id: seasons[currentSeason].videos[indexPath.row].link, startSeconds: nil, endSeconds: nil)
        youTubePlayerViewController.player.configuration = .init(
            fullscreenMode: .system, autoPlay: true, showControls: true, showFullscreenButton: true, useModestBranding: false, playInline: false, showRelatedVideos: false)
        self.show(youTubePlayerViewController, sender: self)
    }
}
