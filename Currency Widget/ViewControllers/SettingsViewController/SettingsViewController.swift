//
//  SettingsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import UIKit
import RxSwift
import RxDataSources

struct SectionOfSettings {
    var header: String
    var items: [Item]
}

extension SectionOfSettings: SectionModelType {
    typealias Item = Property
    
    init(original: SectionOfSettings, items: [Item]) {
        self = original
        self.items = items
    }
}


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
        bindTableView()
    }
    // MARK:  - RX Subscribing
    private func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfSettings>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
                
                cell.nameLabel.text = item.type.rawValue
                cell.valueLabel.text = item.value
                
                return cell
            })
        
        viewModel.rxSettingsList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        tableView.rx.modelSelected(Property.self).subscribe(onNext: { item in
            let vc = ChooseCurrencyViewController()
            vc.modalPresentationStyle = .automatic
            vc.delegate = self
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        
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
        view.backgroundColor = Theme.Color.background
        setupHeaderView()
        setupTopLine()
        setupTableView()

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
        topline.backgroundColor = Theme.Color.mainColorPale
        
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: topline.frame.maxY + view.bounds.height*0.01,
            width: view.bounds.width,
            height: view.bounds.height*0.87)
        )
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        tableView.backgroundColor = Theme.Color.background
        tableView.tableFooterView = UIView() // Dont show unused rows
        //tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard with scrolling
        
        
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

