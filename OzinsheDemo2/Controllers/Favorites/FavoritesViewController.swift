//
//  FavoritesViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import SnapKit
import Localize_Swift

class FavoritesViewController: UIViewController {
    //- MARK: - Variables
    var arrayFavorites: [Movie] = []
    //- MARK: - Outlets
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        tableView.backgroundColor = UIColor.FFFFFF_111827
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.FFFFFF_111827
        navigationItem.title = "LIST".localized()
        setupViews()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        downloadFavorites()
        navigationItem.title = "LIST".localized()
    }
    //- MARK: - add Views
    func setupViews() {
        view.addSubview(tableView)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //- MARK: - Data load
    func downloadFavorites() {
        self.arrayFavorites.removeAll()
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.FAVORITE_URL, method: .get, headers: headers).responseData { response in
            
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
                        self.arrayFavorites.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFavorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.setCellData(movie: arrayFavorites[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieinfoVC = MovieInfoViewController()
        movieinfoVC.movie = arrayFavorites[indexPath.row]
        navigationController?.show(movieinfoVC, sender: self)
    }
}
