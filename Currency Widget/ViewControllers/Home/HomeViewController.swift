//
//  ViewController.swift
//  Currency Widget
//
//  Created by macSlm on 04.10.2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {
    
    
    var headerView = HeaderView()
    var currencyPairsListViewController = CurrencyPairsListViewController()
    var exchangeViewController = ExchangeViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
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

        currencyPairsListViewController.view.frame = CGRect(
            x: 0,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.17)

        exchangeViewController.view.frame = CGRect(
            x: view.bounds.width*0.04,
            y: currencyPairsListViewController.view.frame.maxY + view.bounds.height*0.025,
            width: view.bounds.width*0.92,
            height: view.bounds.height*0.23)


        view.addSubview(headerView)
        view.addSubview(currencyPairsListViewController.view)
        view.addSubview(exchangeViewController.view)

        //pairsTileView.addView.label.text = "Add pair"
    }


}

// MARK:  - SETUP KEYBOARD
extension HomeViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

