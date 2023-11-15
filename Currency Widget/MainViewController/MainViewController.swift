//
//  ViewController.swift
//  Currency Widget
//
//  Created by macSlm on 04.10.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var headerView = HeaderView()
    var currencyTileViewController = TilesUIViewController()
    var exchangeViewController = ExchangeViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
        
        CurrencyFetcher.shared.fetchCurrency(completion: {
            self.currencyTileViewController.data = CurrencyFetcher.shared.currency
            self.currencyTileViewController.collectionView.reloadData()
            //self.navigationBar.baseCurrencyButton.setTitle(CurrencyFetcher.shared.json.base, for: .normal)
            
        })
        
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
        
        headerView = HeaderView(frame: CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height*0.08)
        )
        
        currencyTileViewController.view.frame = CGRect(
            x: 0,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.17)
        
        exchangeViewController.view.frame = CGRect(
            x: view.bounds.width*0.04,
            y: currencyTileViewController.view.frame.maxY + view.bounds.height*0.025,
            width: view.bounds.width*0.92,
            height: view.bounds.height*0.25)
        
        
        view.addSubview(headerView)
        view.addSubview(currencyTileViewController.view)
        view.addSubview(exchangeViewController.view)
        
        //pairsTileView.addView.label.text = "Add pair"
    }


}

