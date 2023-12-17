//
//  CurrencyListTableViewController.swift
//  Currency Widget
//
//  Created by macSlm on 03.12.2023.
//

import UIKit
import RxSwift
import RxDataSources

// MARK:  - Setup sections for RxDataSource

struct SectionOfCurrencyList {
  var header: String
  var items: [Item]
}

extension SectionOfCurrencyList: SectionModelType {
  typealias Item = Currency

   init(original: SectionOfCurrencyList, items: [Item]) {
    self = original
    self.items = items
  }
}


class CurrencyListTableViewController: UIViewController {
    
    let viewModel: CurrencyListViewModelProtocol = CurrencyListViewModel()
    let disposeBag = DisposeBag()
    
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat", "Crypto"])
    var textField = UITextField()
    var tableView = UITableView()
    
    var baseHeightOfElements: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeightOfElements = getBaseHeight()
        
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
}

extension CurrencyListTableViewController: UITableViewDelegate {
    private func setupUI(){
        view.backgroundColor = Theme.Color.background
        setupSegmentedControl()
        setupTextField()
        setupTableView()
        bindTableView()
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.backgroundColor = Theme.Color.background
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard by scrolling
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrencyList>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyListTableViewCell
                
                cell.rxConfigure(currency: item, baseLogo: CoreWorker.shared.currencyList.getBaseCurrency().logo)
                
                return cell
            })
        //        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
        //            return true
        //
        //        }
        
        viewModel.rxFiatList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
                tableView.rx.modelSelected(Currency.self).subscribe(onNext: { item in
                    print ("SELECTED")
                    self.viewModel.selectTail(currency: item)
                }).disposed(by: disposeBag)
        
    }
    
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            textField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: view.bounds.height*0.02),
            textField.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.8)
        ])
        
        textField.layer.cornerRadius = segmentedControl.layer.cornerRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Theme.Color.separator.cgColor
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.backgroundColor = Theme.Color.background
        textField.textColor = Theme.Color.secondText.withAlphaComponent(0.7)
        
    }
}

extension CurrencyListTableViewController {
    
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


