//
//  SimilarListViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 29.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Localize_Swift

class SimilarListViewController: UIViewController {
    //- MARK: - Variables
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
        self.title = "SIMILAR_SERIES".localized()
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
}
//- MARK: - UITableViewDelegate & UITableViewDataSource
extension SimilarListViewController: UITableViewDelegate, UITableViewDataSource {
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
