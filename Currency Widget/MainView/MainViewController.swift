//
//  ViewController.swift
//  Currency Widget
//
//  Created by macSlm on 04.10.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var navigationBar = MainNavigationBar()
    var currencyTileView = TilesUIViewController()
    var pairsTileView = TilesUIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
        
        print("MainVC")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buildInterface()
    }
    
    private func buildInterface() {
        navigationBar = MainNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/10))
        currencyTileView.view.frame = CGRect(x: 0, y: navigationBar.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4)
        pairsTileView.view.frame = CGRect(x: 0, y: currencyTileView.view.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4)
        view.addSubview(navigationBar)
        view.addSubview(currencyTileView.view)
        view.addSubview(pairsTileView.view)
        
        pairsTileView.addView.label.text = "Add pair"
    }


}

