//
//  UITapBarController.swift
//  Currency Widget
//
//  Created by macSlm on 15.11.2023.
//

//  It is also Builder of project

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let homeVC = HomeViewController()
    let listVC = HomeViewController()
    let settingsVC = HomeViewController()
    	
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
//        CurrencyFetcher.shared.fetchCurrency(completion: {
//            self.homeVC.currencyPairsListViewController.collectionView.reloadData()
//        })
        
        CurrencyFetcher.shared.fetchCurrencyDaily(completion: {
            //self.homeVC.currencyPairsListViewController.collectionView.reloadData()
        })
        
        setupTabBarUI()
        setupViewControllers()
    }

    func setupViewControllers() {
        configureHomeVC()
        configureListVC()
        configureSettingsVC()
        viewControllers = [homeVC, listVC, settingsVC]
    }
    
    private func configureHomeVC() {
        let image = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house")
        let item = UITabBarItem(title: "Home", image: image, selectedImage: selectedImage)
        homeVC.tabBarItem = item
    }
    
    private func configureListVC() {
        let image = UIImage(systemName: "list.bullet")
        let selectedImage = UIImage(systemName: "list.bullet")
        let item = UITabBarItem(title: "List", image: image, selectedImage: selectedImage)
        listVC.tabBarItem = item
    }
    
    private func configureSettingsVC() {
        let image = UIImage(systemName: "gear")
        let selectedImage = UIImage(systemName: "gear")
        let item = UITabBarItem(title: "Settings", image: image, selectedImage: selectedImage)
        settingsVC.tabBarItem = item
    }
    
    
    private func setupTabBarUI() {
        tabBar.backgroundColor = Theme.Color.mainColor
//        tabBar.layer.cornerRadius = Theme.Radius.mainWidget
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.tintColor = Theme.Color.background.withAlphaComponent(0.5)
        tabBar.unselectedItemTintColor = Theme.Color.background.withAlphaComponent(0.9)
    }
}
