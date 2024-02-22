//
//  SearchViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage
import SwiftyJSON
import SVProgressHUD

class SearchViewController: UIViewController {
    //- MARK: - Variables
    var categories: [Category] = []
    var movies: [Movie] = []
    var tableViewTopToCollectionViewBottom: Constraint? = nil
    var tableViewTopToTopLabelBottom: Constraint? = nil
    //- MARK: - Local Outlets
    lazy var searchTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Іздеу"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : appearance.c111827_FFFFFF]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : appearance.semiboldFont16, NSAttributedString.Key.foregroundColor : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)])
        textfield.layer.cornerRadius = appearance.textFieldCornerRadius
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
        textfield.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        textfield.addTarget(self,
                            action: #selector(searchTextfieldEditingChange),
                            for: .editingChanged)
        textfield.addTarget(self,
                            action: #selector(searchTextfieldEditingDidBegin),
                            for: .editingDidBegin)
        textfield.addTarget(self,
                            action: #selector(searchTextfieldEditingDidEnd),
                            for: .editingDidEnd)
        textfield.backgroundColor = UIColor.FFFFFF_1_C_2431
        textfield.tintColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
        return textfield
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.F_3_F_4_F_6_374151
        button.layer.cornerRadius = 12
        button.setImage(UIImage(named: "searchButton"), for: .normal)
        button.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Санаттар"
        label.font = appearance.mainTitleFont
        label.textColor = UIColor._111827_FFFFFF
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 128
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.FFFFFF_111827
        return collectionView
    }()
    
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
        navigationItem.title = "Іздеу"
        downloadCategories()
        addViews()
        setupConstraints()
        setupViews()
        setupBorderColor()
        hideKeyboardWhenTappedAround()
    }
    //- MARK: - add & set Views
    func addViews() {
        view.addSubview(searchTextfield)
        view.addSubview(searchButton)
        view.addSubview(cancelSearchButton)
        view.addSubview(topLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    func setupViews() {
        cancelSearchButton.isHidden = true
    }
    
    //- MARK: - Constraints
    func setupConstraints() {
        searchTextfield.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(56)
            make.trailing.equalTo(searchButton.snp.leading).offset(-16)
        }
        searchButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(56)
        }
        cancelSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextfield.snp.centerY)
            make.trailing.equalTo(searchTextfield.snp.trailing)
            make.width.equalTo(52)
            make.height.equalTo(56)
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextfield.snp.bottom).offset(35)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        tableView.snp.makeConstraints { make in
            self.tableViewTopToCollectionViewBottom =  make.top.equalTo(collectionView.snp.bottom).priority(.high).constraint
            self.tableViewTopToTopLabelBottom =  make.top.equalTo(topLabel.snp.bottom).offset(10).priority(.low).constraint
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    //- MARK: - Dark mode(for CGColor)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupBorderColor()
    }
    
    func setupBorderColor(){
        searchTextfield.layer.borderColor = UIColor.Border.signTextfield.cgColor
    }
    //- MARK: - Button Actions
    @objc func searchTextfieldEditingChange() {
        downloadSearchMovies()
    }
    @objc func searchTextfieldEditingDidBegin() {
        searchTextfield.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func searchTextfieldEditingDidEnd() {
        searchTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    @objc func clearSearch() {
        searchTextfield.text = ""
        downloadSearchMovies()
    }
    @objc func startSearch() {
        downloadSearchMovies()
    }
    //- MARK: - Load data
    func downloadCategories() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
            
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
                        let categories = Category(json: item)
                        self.categories.append(categories)
                    }
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
    
    func downloadSearchMovies() {
        
        if searchTextfield.text!.isEmpty {
            topLabel.text = "Санаттар" //"CATEGORIES".localized()
            collectionView.isHidden = false
            tableViewTopToTopLabelBottom?.update(priority: .low)
            tableViewTopToCollectionViewBottom?.update(priority: .high)
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            cancelSearchButton.isHidden = true
            searchButton.setImage(UIImage(named: "searchButton"), for: .normal)
            return
        } else {
            topLabel.text = "Іздеу нәтижелері"//"SEARCH_RESULTS".localized()
            collectionView.isHidden = true
            tableViewTopToTopLabelBottom?.update(priority: .high)
            tableViewTopToCollectionViewBottom?.update(priority: .low)
            tableView.isHidden = false
            cancelSearchButton.isHidden = false
            searchButton.setImage(UIImage(named: "SearchSelectedButton"), for: .normal)
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        let parameters = ["search": searchTextfield.text!]
        
        AF.request(URLs.SEARCH_MOVIES_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            
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
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    for item in array {
                        let movie = Movie(json: item)
                        self.movies.append(movie)
                    }
                 self.tableView.reloadData()
                }
                    else {
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
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! SearchCollectionViewCell
        cell.categoryNameLabel.text = categories[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = categories[indexPath.row].id
        categoryVC.categoryName = categories[indexPath.row].name
        navigationController?.show(categoryVC, sender: self)
    }
}
//- MARK: - UITableViewDelegate & UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.setCellData(movie: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieinfoVC = MovieInfoViewController()
        movieinfoVC.movie = movies[indexPath.row]
        navigationController?.show(movieinfoVC, sender: self)
    }
}
