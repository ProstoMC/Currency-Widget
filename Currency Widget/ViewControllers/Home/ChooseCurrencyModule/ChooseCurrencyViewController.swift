//
//  ChooseCurrencyViewController.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ChooseCurrencyViewController: UIViewController, UITableViewDelegate {
    
    let viewModel: ChooseCurrencyViewModelProtocol = ChooseCurrencyViewModel()
    let disposeBag = DisposeBag()
    
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat", "Crypto"])
    var textField = UITextField()
    var tableView = UITableView()
    
    var baseHeightOfElements: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
        bindTableView()
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrencyList>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChooseCurrencyTableViewCell
                
                cell.configure(shortName: item.shortName, fullname: item.name, logo: item.logo)
                
                return cell
            })
        
        viewModel.rxFiatList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //        collectionView.rx.modelSelected(CurrencyPair.self).subscribe(onNext: {_ in
        //            print ("SELECTED")
        //            self.viewModel.addCell()
        //        }).disposed(by: disposeBug)
        //
    }
}

// MARK:  - SETUP UI
extension ChooseCurrencyViewController {
    private func setupUI() {
        view.backgroundColor = Theme.Color.background
        baseHeightOfElements = getBaseHeight()
        setupSegmentedControl()
        setupTextField()
        setupTableView()
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: baseHeightOfElements/2),
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
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(ChooseCurrencyTableViewCell.self, forCellReuseIdentifier: "cell")
        
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
    
    private func getBaseHeight() -> Double {
        var height = UIScreen.main.bounds.height*0.058
        
        
        if height > 40 {
            height = 40
        } else {
            height = Double(Int(height)) // Deleting fraction
        }
        //print (height)
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Int(baseHeightOfElements*1.2))
    }
}


// MARK:  - SETUP KEYBOARD
extension ChooseCurrencyViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
