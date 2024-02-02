//
//  CurrencyListTableViewController.swift
//  Currency Widget
//
//  Created by macSlm on 03.12.2023.
//

import UIKit
import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import Differentiator


protocol CurrencyListViewModelProtocol {
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var colorSet: AppColors { get }

    func findCurrency(str: String)
   
    var rxUpdateRatesFlag: BehaviorSubject<Bool> { get }
    var rxCoinList: BehaviorRelay<[TableSectionOfCoinUniversal]> { get }
    var typeOfCoin: TypeOfCoin { get set }
    
    func selectTail(coin: CurrencyCellViewModel)
    func resetModel()
}

// MARK:  - Setup sections for RxDataSource




class CurrencyListTableViewController: UIViewController {
    
    var viewModel: CurrencyListViewModelProtocol = CurrencyListViewModelV2(type: .withoutBaseCoin)
    let disposeBag = DisposeBag()
    
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat", "Crypto"])
    var searchBar = UITextField()
    let searchImage = UIImageView()
    
    var tableView = UITableView()
    
    var baseHeightOfElements: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeightOfElements = getBaseHeight()
        
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
        setupUsage()
    }
}

// MARK:  - SETUP USAGE
extension CurrencyListTableViewController {
    
    private func setupUsage(){
        usageTableView()
        usageSegmentedControl()
        usageSearchBar()
        usageColors()
    }
    
    private func usageTableView(){
        let dataSource = RxTableViewSectionedReloadDataSource<TableSectionOfCoinUniversal>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyListTableViewCell
                
                cell.configureWithUniversalCoin(coin: item)
                return cell
            })
        
        viewModel.rxCoinList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CurrencyCellViewModel.self).subscribe(onNext: { item in
            self.viewModel.selectTail(coin: item)
        }).disposed(by: disposeBag)
    }
    
    private func usageSegmentedControl() {
        segmentedControl.rx.value.subscribe(onNext: { index in
            if index == 0 {
                self.viewModel.typeOfCoin = .fiat
                
            }
            if index == 1 {
                self.viewModel.typeOfCoin = .crypto
            }
            self.viewModel.resetModel()
        }).disposed(by: disposeBag)
    }
    
    
    private func usageSearchBar() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                    self.viewModel.findCurrency(str: str)
            }).disposed(by: disposeBag)
        
    }
    
    private func usageColors() {
        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.updateColors()
            }
        }).disposed(by: disposeBag)
    }
}

extension CurrencyListTableViewController: UITableViewDelegate {
    private func setupUI(){
        
        setupSegmentedControl()
        setupTextField()
        setupTableView()
        updateColors()

    }
    
    private func updateColors(){
        view.backgroundColor = viewModel.colorSet.background
        tableView.backgroundColor = viewModel.colorSet.background
        
        segmentedControl.configureColors(
            backgroundColor: viewModel.colorSet.backgroundForWidgets,
            segmentColor: viewModel.colorSet.segmentedControlSegment,
            selectedTextColor: viewModel.colorSet.segmentedControlSelectedText,
            secondTextColor: viewModel.colorSet.segmentedControlSecondText
        )
        
        searchBar.layer.borderColor = viewModel.colorSet.separator.cgColor
        
        searchBar.backgroundColor = viewModel.colorSet.background
        searchBar.textColor = viewModel.colorSet.secondText.withAlphaComponent(0.7)
        searchBar.attributedPlaceholder =
        NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: viewModel.colorSet.secondText])
        searchImage.tintColor = viewModel.colorSet.secondText
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
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.keyboardDismissMode = .onDragWithAccessory // Close the keyboard by scrolling
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
        
        searchBar.clearButtonMode = .always
        searchBar.borderStyle = .roundedRect
        searchBar.keyboardType = .default

        
        //Add left view and make it transparent
        searchBar.leftViewMode = .always
        searchBar.leftView?.contentMode = .center
        searchBar.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchBar.leftView?.tintColor = .white.withAlphaComponent(0)
        
        //Setup color of clearButton
        if let clearButton = searchBar.value(forKey: "_clearButton") as? UIButton {
             let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
             clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = viewModel.colorSet.clearButton
         }
        
        //Create custom image view and adding to search bar
        searchImage.image = UIImage(systemName: "magnifyingglass")
        
        searchImage.contentMode = .scaleAspectFit
        self.view.addSubview(searchImage)
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchImage.leftAnchor.constraint(equalTo: searchBar.leftAnchor, constant: baseHeightOfElements*0.15),
            searchImage.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchImage.heightAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
            searchImage.widthAnchor.constraint(equalToConstant: baseHeightOfElements*0.5),
        ])
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


