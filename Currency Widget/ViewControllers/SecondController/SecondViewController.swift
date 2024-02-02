//
//  CurrencyListViewController.swift
//  Currency Widget
//
//  Created by macSlm on 30.11.2023.
//

import UIKit
import RxSwift

class SecondViewController: UIViewController {
    let bag = DisposeBag()
    
    var headerView: HeaderView!
    var tableViewController = CurrencyListTableViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
    }

}
// MARK:  - SETUP UI
extension SecondViewController {
    private func setupUI() {
        view.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().background
        
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.view.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().background
            }
        }).disposed(by: bag)
        
        headerView = HeaderView(frame: CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height*0.08)
        )
        tableViewController.view.frame = CGRect(
            x: 0,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.87)
        
        view.addSubview(headerView)
        view.addSubview(tableViewController.view)
    }
}

// MARK:  - SETUP KEYBOARD
extension SecondViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
