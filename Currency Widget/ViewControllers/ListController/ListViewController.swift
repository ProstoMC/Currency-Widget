//
//  CurrencyListViewController.swift
//  Currency Widget
//
//  Created by macSlm on 30.11.2023.
//

import UIKit

class ListViewController: UIViewController {
    
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
extension ListViewController {
    private func setupUI() {
        view.backgroundColor = Theme.Color.background
        
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
            height: view.bounds.height*0.92)
        
        view.addSubview(headerView)
        view.addSubview(tableViewController.view)
    }
}

// MARK:  - SETUP KEYBOARD
extension ListViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
