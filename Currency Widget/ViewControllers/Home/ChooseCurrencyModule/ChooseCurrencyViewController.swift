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

protocol ReturnDataFromChooseViewControllerProtocol {
    func passCurrencyShortName(name: String?)
}


class ChooseCurrencyViewController: UIViewController, UITableViewDelegate {
    
    var delegate: ReturnDataFromChooseViewControllerProtocol!
    
    //We have to provide type of VM from mother VC
    var viewModel: CurrencyListViewModelProtocol = CurrencyListViewModelV2(type: .fullList)
    let disposeBag = DisposeBag()
    
    var closingLine = UIView()
    var segmentedControl = CornersWhiteSegmentedControl(items: ["Fiat", "Crypto"])
    var searchBar = UITextField()
    let searchImage = UIImageView()
    
    var tableView = UITableView()
    
    var baseHeightOfElements: Double!
    
    var choosenCurrencyName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUI()
        subscribing()
        usageSegmentedControl()
        usageSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate.passCurrencyShortName(name: choosenCurrencyName)
    }
    
    private func subscribing() {
        let dataSource = RxTableViewSectionedReloadDataSource<TableSectionOfCoinUniversal>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChooseCurrencyTableViewCell
                
                cell.configure(coin: item)
                
                return cell
            })
        
        viewModel.rxCoinList.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CurrencyCellViewModel.self).subscribe(onNext: { item in
            //print ("SELECTED")
            //self.viewModel.setCurrency(shortName: item.shortName)
            self.choosenCurrencyName = item.code
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.updateColors()
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func usageSegmentedControl() {
        segmentedControl.rx.value.subscribe{ index in
            if index == 0 {
                self.viewModel.typeOfCoin = .fiat
            }
            if index == 1 {
                self.viewModel.typeOfCoin = .crypto
            }
            self.viewModel.resetModel()
        }.disposed(by: disposeBag)
    }
    
    private func usageSearchBar() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                self.viewModel.findCurrency(str: str)
            }).disposed(by: disposeBag)
        
        
    }
}

// MARK:  - SETUP UI
extension ChooseCurrencyViewController {
    private func setupUI() {
        
        baseHeightOfElements = getBaseHeight()
        setupClosingLine()
        setupSegmentedControl()
        setupTextField()
        setupTableView()
        updateColors()
    }
    
    private func updateColors(){
        
        view.backgroundColor = viewModel.colorSet.background
        closingLine.backgroundColor = viewModel.colorSet.closingLine
        
        searchBar.backgroundColor = viewModel.colorSet.background
        searchBar.textColor = viewModel.colorSet.secondText.withAlphaComponent(0.7)
        searchBar.attributedPlaceholder =
        NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: viewModel.colorSet.secondText])
        searchBar.layer.borderColor = viewModel.colorSet.separator.cgColor
        searchImage.tintColor = viewModel.colorSet.secondText
        
        tableView.backgroundColor = viewModel.colorSet.background
        
        segmentedControl.configureColors(
            backgroundColor: viewModel.colorSet.backgroundForWidgets,
            segmentColor: viewModel.colorSet.segmentedControlSegment,
            selectedTextColor: viewModel.colorSet.segmentedControlSelectedText,
            secondTextColor: viewModel.colorSet.segmentedControlSecondText
        )
        
        
    }
    
    private func setupClosingLine() {
        view.addSubview(closingLine)
        closingLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closingLine.topAnchor.constraint(equalTo: view.topAnchor, constant: baseHeightOfElements/3),
            closingLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closingLine.heightAnchor.constraint(equalToConstant: baseHeightOfElements/8),
            closingLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
        ])
        
        closingLine.layer.cornerRadius = baseHeightOfElements/16
        
        
        
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            segmentedControl.topAnchor.constraint(equalTo: closingLine.bottomAnchor, constant: baseHeightOfElements/3),
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
        //Set normal appearing for search bar
        searchBar.layer.cornerRadius = segmentedControl.layer.cornerRadius
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        
        searchBar.clearButtonMode = .always
        searchBar.borderStyle = .roundedRect
        searchBar.keyboardType = .default

        
        //Setup color of clearButton
        if let clearButton = searchBar.value(forKey: "_clearButton") as? UIButton {
             let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
             clearButton.setImage(templateImage, for: .normal)
             clearButton.tintColor = viewModel.colorSet.segmentedControlSegment
         }
        
        //Add left view and make it transparent
        searchBar.leftViewMode = .always
        searchBar.leftView?.contentMode = .center
        searchBar.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchBar.leftView?.tintColor = .white.withAlphaComponent(0) //Just hide it
        
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
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(ChooseCurrencyTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width*0.04),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width*0.04),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: view.bounds.height*0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.keyboardDismissMode = .interactiveWithAccessory // Close the keyboard by scrolling
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
