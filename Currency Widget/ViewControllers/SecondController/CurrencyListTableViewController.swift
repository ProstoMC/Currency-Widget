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
    
    var viewModel: CurrencyListViewModelProtocol = CurrencyListViewModel()
    let disposeBag = DisposeBag()
    
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat", "Crypto"])
    var searchBar = UITextField()
    
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
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.backgroundColor = Theme.Color.background
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .onDragWithAccessory // Close the keyboard by scrolling
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCurrencyList>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyListTableViewCell
                
                cell.rxConfigure(currency: item, baseLogo: CoreWorker.shared.currencyList.getBaseCurrency().logo)
                
                return cell
            })
        
        viewModel.rxFiatList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Currency.self).subscribe(onNext: { item in
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
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: view.bounds.height*0.02),
            searchBar.heightAnchor.constraint(equalToConstant: baseHeightOfElements)
        ])
        
        searchBar.layer.cornerRadius = segmentedControl.layer.cornerRadius
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Theme.Color.separator.cgColor
        searchBar.clearButtonMode = .always
        searchBar.borderStyle = .roundedRect
        searchBar.keyboardType = .default
        searchBar.backgroundColor = Theme.Color.background
        searchBar.textColor = Theme.Color.secondText.withAlphaComponent(0.7)
        searchBar.attributedPlaceholder =
        NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: Theme.Color.secondText])
        
        //Add left view and make it transparent
        searchBar.leftViewMode = .always
        searchBar.leftView?.contentMode = .center
        searchBar.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchBar.leftView?.tintColor = .white.withAlphaComponent(0)
        
        //Setup color of clearButton
        if let clearButton = searchBar.value(forKey: "_clearButton") as? UIButton {
             let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
             clearButton.setImage(templateImage, for: .normal)
             clearButton.tintColor = Theme.Color.segmentedControlBackground
         }
        
        //Create custom image view and adding to search bar
        let searchImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImage.tintColor = Theme.Color.secondText
        searchImage.contentMode = .scaleAspectFit
        self.view.addSubview(searchImage)
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchImage.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: baseHeightOfElements*0.15),
            searchImage.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchImage.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
            searchImage.widthAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
        ])
        
        //RX Part
        
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
//                if str != "" {
                    self.viewModel.findCurrency(str: str)
//                }
            }).disposed(by: disposeBag)
        
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

// MARK:  - SETUP KEYBOARD
extension CurrencyListTableViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}


