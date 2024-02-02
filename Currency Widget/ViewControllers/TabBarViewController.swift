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
    let topLineView = UIView()
    
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
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe{_ in
            self.selectedIndex = 0
        }.disposed(by: bag)
        
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.setupTabBarUI()
            })
        }.disposed(by: bag)
        
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
        tabBar.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().tabBarBackground
        tabBar.itemPositioning = .centered

        tabBar.tintColor = CoreWorker.shared.colorsWorker.returnColors().tabBarText.withAlphaComponent(1)
        tabBar.unselectedItemTintColor = CoreWorker.shared.colorsWorker.returnColors().tabBarText.withAlphaComponent(0.5)
        
        self.view.addSubview(topLineView)
        topLineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),
        ])

        topLineView.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().tabBarLine
        
 

    }
}
