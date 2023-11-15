//
//  UITapBarController.swift
//  Currency Widget
//
//  Created by macSlm on 15.11.2023.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    	
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBarUI()
        setupViewControllers()
    }

    func setupViewControllers() {
        let homeVC = configureHomeVC()
        let listVC = configureListVC()
        let settingsVC = configureSettingsVC()
        viewControllers = [homeVC, listVC, settingsVC]
    }
    
    private func configureHomeVC() -> MainViewController {
        let vc = MainViewController()
        
        let image = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house")
        
        let item = UITabBarItem(title: "Home", image: image, selectedImage: selectedImage)
        vc.tabBarItem = item
        return vc
    }
    
    private func configureListVC() -> MainViewController {
        let vc = MainViewController()
        
        let image = UIImage(systemName: "list.bullet")
        let selectedImage = UIImage(systemName: "list.bullet")
        
        let item = UITabBarItem(title: "List", image: image, selectedImage: selectedImage)
        vc.tabBarItem = item
        
        return vc
    }
    
    private func configureSettingsVC() -> MainViewController {
        let vc = MainViewController()
        
        let image = UIImage(systemName: "gear")
        let selectedImage = UIImage(systemName: "gear")
        
        let item = UITabBarItem(title: "Settings", image: image, selectedImage: selectedImage)
        vc.tabBarItem = item
        
        return vc
    }
    
    
    private func setupTabBarUI() {
        tabBar.backgroundColor = Theme.Color.mainColor
        tabBar.layer.cornerRadius = Theme.Radius.mainWidget
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.tintColor = Theme.Color.background.withAlphaComponent(0.5)
        tabBar.unselectedItemTintColor = Theme.Color.background.withAlphaComponent(0.9)
    }
}
