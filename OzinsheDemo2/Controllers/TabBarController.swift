//
//  TabBarController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        tabBar.backgroundColor = UIColor(named: "FFFFFF - 1C2431")
        tabBar.barTintColor = UIColor(named: "FFFFFF - 1C2431")
        
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected")?.withRenderingMode(.alwaysOriginal))
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), selectedImage: UIImage(named: "SearchSelected")?.withRenderingMode(.alwaysOriginal))
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favorite"), selectedImage: UIImage(named: "FavoriteSelected")?.withRenderingMode(.alwaysOriginal))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected")?.withRenderingMode(.alwaysOriginal))
        
        setViewControllers([homeVC, searchVC, favoritesVC, profileVC], animated: false)
    }
}
