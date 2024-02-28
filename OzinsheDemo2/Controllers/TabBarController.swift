//
//  TabBarController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    // - MARK: - Variables
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    let searchVC = UINavigationController(rootViewController: SearchViewController())
    let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    // - MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupSelectedImage()
    }
    // - MARK: - Settings
    func setupTabs() {
        tabBar.backgroundColor = UIColor(named: "FFFFFF - 1C2431")
        tabBar.barTintColor = UIColor(named: "FFFFFF - 1C2431")
        tabBar.isTranslucent = false
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal))
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), selectedImage: UIImage(named: "SearchSelected")!.withRenderingMode(.alwaysOriginal))
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favorite"), selectedImage: UIImage(named: "FavoriteSelected")!.withRenderingMode(.alwaysOriginal))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal))
 
        setViewControllers([homeVC, searchVC, favoritesVC, profileVC], animated: false)
    }
    // - MARK: - Dark theme
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupSelectedImage()
    }
    
    func setupSelectedImage(){
        homeVC.tabBarItem.selectedImage = UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal)
        searchVC.tabBarItem.selectedImage = UIImage(named: "SearchSelected")!.withRenderingMode(.alwaysOriginal)
        favoritesVC.tabBarItem.selectedImage = UIImage(named: "FavoriteSelected")!.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal)
    }
}
