//
//  CategoryViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 22.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CategoryViewController: UIViewController {
    //- MARK: - Variables
    var categoryID: Int = 0
    var categoryString: String = ""
    var categoryName = ""
    var movies: [Movie] = []
    //- MARK: - Local Outlets
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        self.title = categoryName
        downloadMoviesByCategory()
        setupViews()
        setupConstraints()
    }
    //- MARK: - Setup View
    func setupViews() {
        view.addSubview(tableView)
    }
    //- MARK: - Setup Constraints
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //- MARK: - Load Data
    func downloadMoviesByCategory() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        let parameters = [categoryString: categoryID]
        
        AF.request(URLs.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json["content"].exists() {
                    if let array = json["content"].array {
                        for item in array {
                            let movies = Movie(json: item)
                            self.movies.append(movies)
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
}
//- MARK: - UITableViewDelegate & UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        cell.setCellData(movie: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = MovieInfoViewController()
        movieInfoVC.movie = movies[indexPath.row]
        navigationController?.show(movieInfoVC, sender: self)
    }
}
