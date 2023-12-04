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
    
    var segmentedControl = UISegmentedControl(items: ["Fiat", "Crypto"])
    var textField = UITextField()
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension CurrencyListTableViewController {
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
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrencyList>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
              
              cell.textLabel?.text = String(item.name)
              
            return cell
          })
//        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
//            return true
//
//        }
        
        //viewModel.pairList.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBug)
        
//        collectionView.rx.modelSelected(CurrencyPair.self).subscribe(onNext: {_ in
//            print ("SELECTED")
//            self.viewModel.addCell()
//        }).disposed(by: disposeBug)
//
    }
    
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.055)
        ])
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.backgroundColor = UIColor.white.cgColor
        segmentedControl.selectedSegmentTintColor = Theme.Color.mainColor
        
        let selectedTextColor = [NSAttributedString.Key.foregroundColor: Theme.Color.backgroundForWidgets]
        let normalTextColor = [NSAttributedString.Key.foregroundColor: Theme.Color.mainColor]
        
        segmentedControl.setTitleTextAttributes(selectedTextColor, for: .selected)
        segmentedControl.setTitleTextAttributes(normalTextColor, for: .normal)
        
        fixBackgroundSegmentControl(segmentedControl)     //Making white background

    }
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            textField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: view.bounds.height*0.02),
            textField.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.05)
        ])
    
        textField.layer.cornerRadius = Theme.Radius.minimal
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Theme.Color.separator.cgColor
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.backgroundColor = Theme.Color.background
        textField.textColor = Theme.Color.secondText.withAlphaComponent(0.7)
        
    }
    
    
    //Making white background
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}


