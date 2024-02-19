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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //- MARK: - Variables
    var mainMovies: [MainMovies] = []
    
    //- MARK: - Local Outlets
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        downloadMainBanners()
        setUI()
        addNavBarImage()
        
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
    
    //- MARK: - Table view
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
                let cell = MainBannerTableViewCell() //tableView.dequeueReusableCell(withIdentifier: "mainBannerCell", for: indexPath) as! MainBannerTableViewCell
                
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                //cell.delegate = self
                return cell
            }()
        case .userHistory:
            return {
                let cell = MainHistoryTableViewCell() //tableView.dequeueReusableCell(withIdentifier: "mainHistoryCell", for: indexPath) as! MainHistoryTableViewCell
                
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                //cell.delegate = self
                return cell
            }()
        case .genre:
            return {
                let cell = MainAgeGenreTableViewCell() //tableView.dequeueReusableCell(withIdentifier: "mainAgeGenreCell", for: indexPath) as! MainAgeGenreTableViewCell
                
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                //cell.delegate = self
                return cell
            }()
        case .ageCategory:
            return {
                let cell = MainAgeGenreTableViewCell() //tableView.dequeueReusableCell(withIdentifier: "mainAgeGenreCell", for: indexPath) as! MainAgeGenreTableViewCell
                
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                //cell.delegate = self
                return cell
            }()
        case .mainMovie:
            return {
                let cell = MainMovieTableViewCell()// tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainMovieTableViewCell
                cell.setCellData(mainMovie: mainMovies[indexPath.row])
                if cell.collectionView.isHidden {
                    tableView.isHidden = true
                }
                //cell.delegate = self
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
    
    // - MARK: Data loading -
    func downloadMainBanners() {
        //SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.MAIN_BANNERS_URL, method: .get, headers: headers).responseData { response in
            
            //SVProgressHUD.dismiss()
            
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .mainBanner
                    for item in array {
                        let bannerMovie = BannerMovie(json: item)
                        movie.bannerMovie.append(bannerMovie)
                    }
                    self.mainMovies.append(movie)
                    self.tableView.reloadData()
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
            self.downloadUserHistory()
        }
        
    }
    
    // load step 2
    func downloadUserHistory() {
        //SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.USER_HISTORY_URL, method: .get, headers: headers).responseData { response in
            
            //SVProgressHUD.dismiss()
            
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .userHistory
                    for item in array {
                        let historyMovie = Movie(json: item)
                        movie.movies.append(historyMovie)
                    }
                    if array.count > 0 {
                        self.mainMovies.append(movie)
                    }
                    print(self.mainMovies.count)
                    self.tableView.reloadData()
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
            self.downloadMainMovies()
        }
        
    }
    
    // load step 3
    func downloadMainMovies() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.MAIN_MOVIES_URL, method: .get, headers: headers).responseData { response in
            
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
                        let movie = MainMovies(json: item)
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
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
            self.downloadGenres()
        }
        
    }
    
    // load step 4
    func downloadGenres() {
        //SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_GENRES, method: .get, headers: headers).responseData { response in
            
            //SVProgressHUD.dismiss()
            
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .genre
                    for item in array {
                        let genre = Genre(json: item)
                        movie.genres.append(genre)
                    }
                    if self.mainMovies.count > 4 {
                    if self.mainMovies[1].cellType == .userHistory {
                            self.mainMovies.insert(movie, at: 4)
                        } else {
                            self.mainMovies.insert(movie, at: 3)
                        }
                    }
                    else {
                        self.mainMovies.append(movie)
                    }
                    
                    self.tableView.reloadData()
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
            self.downloadCategoryAges()
        }
        
    }
    
    // load step 5
    func downloadCategoryAges() {
        //SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_AGES, method: .get, headers: headers).responseData { response in
            
            //SVProgressHUD.dismiss()
            
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .ageCategory
                    for item in array {
                        let ageCategory = CategoryAge(json: item)
                        movie.categoryAges.append(ageCategory)
                    }
                    
                    if self.mainMovies.count > 8 {
                        if self.mainMovies[1].cellType == .userHistory {
                            self.mainMovies.insert(movie, at: 8)
                        } else {
                            self.mainMovies.insert(movie, at: 7)
                        }
                    }
                    else {
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
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
