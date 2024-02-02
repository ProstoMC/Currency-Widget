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
    let bag = DisposeBag()
    
    var headerView = HeaderView()
    
    var scrollView = UIScrollView()
    var refreshControl = UIRefreshControl()
    
    var currencyPairsListViewController = CurrencyPairsListViewController()
    var exchangeViewController = ExchangeViewController()
    var detailsViewController = DetailsViewController()
    
    var isUpdating = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().background
        subscribing()
        setupScrollView()
 
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buildInterface()
        
    }
    
    private func subscribing() {
        //Update colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.view.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().background
            }
        }).disposed(by: bag)
        //End refreshing
        CoreWorker.shared.coinList.rxRateUpdated.subscribe{ _ in
            
            self.refreshControl.endRefreshing()
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.isUpdating = false
        }.disposed(by: bag)
    }

    private func buildInterface() {

        headerView = HeaderView(frame: CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height*0.08)
        )
        
        scrollView.frame = CGRect(
            x: 0,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.9)
        

        currencyPairsListViewController.view.frame = CGRect(
            x: 0,
            y: scrollView.bounds.minY,
            width: scrollView.bounds.width,
            height: view.bounds.height*0.17)

        exchangeViewController.view.frame = CGRect(
            x: view.bounds.width*0.04,
            y: currencyPairsListViewController.view.frame.maxY + view.bounds.height*0.025,
            width: scrollView.bounds.width*0.92,
            height: view.bounds.height*0.25)
        
        detailsViewController.view.frame = CGRect(
            x: view.bounds.width*0.04,
            y: exchangeViewController.view.frame.maxY,
            width: scrollView.bounds.width*0.92,
            height: view.bounds.height*0.35)


        view.addSubview(headerView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(currencyPairsListViewController.view)
        scrollView.addSubview(exchangeViewController.view)
        scrollView.addSubview(detailsViewController.view)
        
        

    }
    
    private func setupScrollView() {
//        let currencyPairModuleHeight = currencyPairsListViewController.view.bounds.height
//        let exchangeModuleHeight = exchangeViewController.view.bounds.height
//        let detailsModuleHeight = detailsViewController.view.bounds.height
        //scrollView.contentSize.height = currencyPairModuleHeight + exchangeModuleHeight + detailsModuleHeight
        scrollView.contentSize.height = UIScreen.main.bounds.height
        
        scrollView.refreshControl = refreshControl
        scrollView.alwaysBounceVertical = true
        
        
        refreshControl.addTarget(self, action: #selector(onRefresh(send:)), for: .valueChanged)
        refreshControl.transform = CGAffineTransformMakeScale(0.75, 0.75)
    }
    
    @objc func onRefresh(send: UIRefreshControl) {
        print(isUpdating)
        if !isUpdating {
            isUpdating = true
            CoreWorker.shared.coinList.updateRatesFromEth()
        }
        
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
