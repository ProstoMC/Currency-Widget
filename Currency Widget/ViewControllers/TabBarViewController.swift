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
    
    let bag = DisposeBag()
    
    let homeVC = HomeViewController()
    let listVC = SecondViewController()
    let settingsVC = SettingsViewController()
    
    let backgroundView = UIView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        
        setupTabBarUI()
        setupViewControllers()
        setupRx()
    }
    
    override func viewWillLayoutSubviews() {

    }
    
    private func setupRx() {
        //Return to first VC
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe(onNext: {_ in
            self.selectedIndex = 0
        }).disposed(by: bag)
    }
    
}

// MARK:  - SETUP UI
extension TabBarViewController {
    
   
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
        tabBar.backgroundColor = Theme.Color.tabBarBackground
        tabBar.itemPositioning = .centered
        //tabBar.itemSpacing = UIScreen.main.bounds.width/30
        
//        tabBar.layer.cornerRadius = Theme.Radius.mainWidget
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.tintColor = Theme.Color.tabBarText.withAlphaComponent(1)
        tabBar.unselectedItemTintColor = Theme.Color.tabBarText.withAlphaComponent(0.5)
        
        
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        tabBar.addSubview(backgroundView)
//        backgroundView.backgroundColor = Theme.Color.mainColor
//
//        NSLayoutConstraint.activate([
//            backgroundView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
//            backgroundView.topAnchor.constraint(equalTo: tabBar.topAnchor),
//            backgroundView.widthAnchor.constraint(equalTo: tabBar.widthAnchor, multiplier: 0.45),
//            backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/20),
//            //backgroundView.height.constraint(equalToConstant: tabBarItem.accessibilityPath?.bounds.height)
//        ])
//
//        self.title = nil
//
//        backgroundView.layer.masksToBounds = true
//        backgroundView.layer.cornerRadius = 5
    }
}
