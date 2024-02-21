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
        tabBar.isTranslucent = false
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected"))
        searchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), selectedImage: UIImage(named: "SearchSelected"))
        favoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favorite"), selectedImage: UIImage(named: "FavoriteSelected"))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected"))
        
        setViewControllers([homeVC, searchVC, favoritesVC, profileVC], animated: false)
    }
}
