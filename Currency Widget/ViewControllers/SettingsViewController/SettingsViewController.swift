//
//  SettingsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import UIKit
import RxSwift

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModelProtocol = SettingsViewModel()
    let disposeBag = DisposeBag()
    
    var headerView: HeaderView!
    var topline: UIView!
    var tableView: UITableView!
    
    var baseHeightOfElements: Double!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeightOfElements = getBaseHeight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
        rxSubscribing()
    }
    
    // MARK:  - RX Subscribing
    private func rxSubscribing() {

        //Update colors
        viewModel.rxAppThemeUpdated.subscribe { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.colorsUpdate()
            })

        }.disposed(by: disposeBag)
    }

}
extension SettingsViewController: ReturnDataFromChooseViewControllerProtocol {
    func passCurrencyShortName(name: String?) {
        if name != nil {
            viewModel.changeBaseCurrency(name: name!)
        }
    }
}
// MARK:  - SEUP UI
extension SettingsViewController {
    private func setupUI() {
        
        setupHeaderView()
        setupTopLine()
        setupTableView()
        colorsUpdate()
    }
    
    private func setupHeaderView() {
        
        headerView = HeaderView(frame: CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height*0.08)
        )
        
        view.addSubview(headerView)
    }
    
    private func setupTopLine() {
        topline = UIView(frame: CGRect(
            x: view.bounds.width / 25,
            y: headerView.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width - view.bounds.width / 25,
            height: 1)
        )
        
        view.addSubview(topline)
        
        
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: topline.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.87)
        )
        view.addSubview(tableView)
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        //tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard with scrolling
        
    }
    private func colorsUpdate() {
        view.backgroundColor = viewModel.colorSet.background
        topline.backgroundColor = viewModel.colorSet.border
        tableView.backgroundColor = viewModel.colorSet.background
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.settingsList.count)
        return viewModel.settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        cell.dataConfigure(viewModel: viewModel.settingsList[indexPath.row])
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    private func getBaseHeight() -> Double {
        var height = UIScreen.main.bounds.height*0.058
        
        
        if height > 40 {
            height = 40
        } else {
            height = Double(Int(height)) // Deleting fraction
        }
        print (height)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return baseHeightOfElements*1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Base currency
        if indexPath.row == 0 { changeBaseCurrency() }
        //App theme
        if indexPath.row == 1 { changeThemeAlert() }
    }
    

    
    
}



// MARK:  - CELL TAPPED
extension SettingsViewController {
    func changeBaseCurrency() {
        let vc = ChooseCurrencyViewController()
        vc.modalPresentationStyle = .automatic
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func changeThemeAlert() {

        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "System", style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .system)
        })
        )
        alert.addAction(UIAlertAction(title: "Light", style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .light)
        })
        )
        alert.addAction(UIAlertAction(title: "Dark", style: .default, handler: {_ in
            self.viewModel.changeTheme(theme: .dark)
        })
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:  - SETUP KEYBOARD
extension SettingsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

