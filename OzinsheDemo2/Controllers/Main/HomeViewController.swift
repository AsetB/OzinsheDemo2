//
//  HomeViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit
import SnapKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import Localize_Swift

class HomeViewController: UIViewController {
    //- MARK: - Variables
    var mainMovies: [MainMovies] = []
    
    //- MARK: - Local Outlets
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MainBannerTableViewCell.self, forCellReuseIdentifier: "mainBannerCell")
        tableView.register(MainMovieTableViewCell.self, forCellReuseIdentifier: "mainCell")
        tableView.register(MainHistoryTableViewCell.self, forCellReuseIdentifier: "mainHistoryCell")
        tableView.register(MainAgeGenreTableViewCell.self, forCellReuseIdentifier: "mainAgeGenreCell")
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        addNavBarImage()
        loadData()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //- MARK: - Setup View
    func setUI() {
        navigationItem.title = " "
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func addNavBarImage() {
        let image = UIImage(named: "logoMainPage")
        let logoImageView = UIImageView(image: image)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = imageItem
    }

    // - MARK: - Data loading refactored
    func loadData() {
        downloadData(from: URLs.MAIN_BANNERS_URL, cellType: .mainBanner) { [weak self ] in
            self?.downloadData(from: URLs.USER_HISTORY_URL, cellType: .userHistory) {
                self?.downloadData(from: URLs.MAIN_MOVIES_URL, cellType: .mainMovie) {
                    self?.downloadData(from: URLs.GET_GENRES, cellType: .genre) {
                        self?.downloadData(from: URLs.GET_AGES, cellType: .ageCategory) {}
                    }
                }
            }
        }
    }
    func downloadData(from url: String, cellType: CellType, completion: @escaping () -> Void) {
        SVProgressHUD.show()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(url, method: .get, headers: headers).responseData { [weak self] response in
            SVProgressHUD.dismiss()
            guard let responseCode = response.response?.statusCode else {
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                return
            }
            switch responseCode {
            case 200:
                let json = JSON(response.data!)
                let movie = MainMovies()
                movie.cellType = cellType
                switch cellType {
                case .mainBanner:
                    if let array = json.array {
                        for item in array {
                            let bannerMovie = BannerMovie(json: item)
                            movie.bannerMovie.append(bannerMovie)
                        }
                        self?.mainMovies.append(movie)
                        self?.tableView.reloadData()
                    }
                case .userHistory:
                    if let array = json.array {
                        for item in array {
                            let historyMovie = Movie(json: item)
                            movie.movies.append(historyMovie)
                        }
                        if array.count > 0 {
                            self?.mainMovies.append(movie)
                        }
                        self?.tableView.reloadData()
                    }
                case .mainMovie:
                    if let array = json.array {
                        for item in array {
                            let movie = MainMovies(json: item)
                            self?.mainMovies.append(movie)
                        }
                        self?.tableView.reloadData()
                    }
                case .genre:
                    if let array = json.array {
                        for item in array {
                            let genre = Genre(json: item)
                            movie.genres.append(genre)
                        }
                        if (self?.mainMovies.count)! > 4 {
                        if self?.mainMovies[1].cellType == .userHistory {
                                self?.mainMovies.insert(movie, at: 4)
                            } else {
                                self?.mainMovies.insert(movie, at: 3)
                            }
                        }
                        else {
                            self?.mainMovies.append(movie)
                        }
                        
                        self?.tableView.reloadData()
                    }
                case .ageCategory:
                    if let array = json.array {
                        let movie = MainMovies()
                        movie.cellType = .ageCategory
                        for item in array {
                            let ageCategory = CategoryAge(json: item)
                            movie.categoryAges.append(ageCategory)
                        }
                        if (self?.mainMovies.count)! > 8 {
                            if self?.mainMovies[1].cellType == .userHistory {
                                self?.mainMovies.insert(movie, at: 8)
                            } else {
                                self?.mainMovies.insert(movie, at: 7)
                            }
                        }
                        else {
                            self?.mainMovies.append(movie)
                        }
                        self?.tableView.reloadData()
                    }
                }
            default:
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                }
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            completion()
        }
    }
}
    //- MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mainMovies[indexPath.row].cellType {
        case .mainBanner:
            return {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainBannerCell") as! MainBannerTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                cell.delegate = self
                return cell
            }()
        case .userHistory:
            return {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainHistoryCell") as! MainHistoryTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                cell.delegate = self
                return cell
            }()
        case .genre:
            return {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainAgeGenreCell") as! MainAgeGenreTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                cell.delegate = self
                return cell
            }()
        case .ageCategory:
            return {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainAgeGenreCell") as! MainAgeGenreTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                cell.delegate = self
                return cell
            }()
        case .mainMovie:
            return {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainMovieTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                cell.delegate = self
                return cell
            }()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mainMovies[indexPath.row].cellType {
        case .mainBanner:
            return 272
        case .userHistory:
            return 228
        case .genre:
            return 184
        case .ageCategory:
            return 184
        case .mainMovie:
            return 288
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if mainMovies[indexPath.row].cellType != .mainMovie {
            return
        }
        
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = mainMovies[indexPath.row].categoryId
        categoryVC.categoryName = mainMovies[indexPath.row].categoryName
        navigationController?.show(categoryVC, sender: self)
    }
}

//- MARK: - ItemDidSelect
extension HomeViewController: ItemDidSelect {
    func movieDidSelect(movie: Movie) {
        let movieInfoVC = MovieInfoViewController()
        movieInfoVC.movie = movie
        navigationController?.show(movieInfoVC, sender: self)
    }
    
    func genreDidSelect(genreID: Int, genreName: String) {
        let categoryString = "genreId"
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = genreID
        categoryVC.categoryName = genreName
        categoryVC.categoryString = categoryString
        navigationController?.show(categoryVC, sender: self)
    }
    
    func ageDidSelect(ageID: Int, ageName: String) {
        let categoryString = "categoryAgeId"
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = ageID
        categoryVC.categoryName = ageName
        categoryVC.categoryString = categoryString
        navigationController?.show(categoryVC, sender: self)
    }
}
