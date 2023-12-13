//
//  ExchangeView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit
import Foundation
import RxSwift

class ExchangeViewController: UIViewController {
    
    let viewModel: ExchangeViewModelProtocol = ExchangeViewModel()
    let disposeBag = DisposeBag()
    
    let exchangeLabel = UILabel()
    let changeButton = UIButton()
    
    let fromView = EnterCurrencyView()
    let toView = EnterCurrencyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .yellow
        setupRx()
        setupUI()
    }

}
// MARK:  SETUP RX
extension ExchangeViewController {
    private func setupRx() {
        
        //Setting to FromView
        viewModel.fromText.subscribe(onNext: { text in
            self.fromView.textField.text = text
            if text != "1.0" {
                self.fromView.textField.textColor = Theme.Color.mainText
                self.toView.textField.textColor = Theme.Color.mainText
            }
        }).disposed(by: disposeBag)
        
        //Setting to ToView
        viewModel.toText.subscribe(onNext: { text in
            self.toView.textField.text = text
        }).disposed(by: disposeBag)
        
        //Setting currency names
        viewModel.fromCurrency.subscribe(onNext: { text in
            self.fromView.currencyButton.setTitle(" \(text)", for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.toCurrency.subscribe(onNext: { text in
            self.toView.currencyButton.setTitle(" \(text)", for: .normal)
        }).disposed(by: disposeBag)
        
        
        //Getting from FromView
        fromView.textField.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                self.viewModel.fromText.on(.next(str))
                self.viewModel.makeExchangeNormal()
                
                if str == "1" {
                    self.fromView.textField.textColor = Theme.Color.secondText.withAlphaComponent(0.7)
                    self.toView.textField.textColor = Theme.Color.secondText.withAlphaComponent(0.7)
                } else {
                    self.fromView.textField.textColor = Theme.Color.mainText
                    self.toView.textField.textColor = Theme.Color.mainText
                }
            }).disposed(by: disposeBag)
        
        //Getting from ToView
        toView.textField.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { str in
                self.viewModel.toText.on(.next(str))
                self.viewModel.makeExchangeReverse()

            }).disposed(by: disposeBag)
        
        //Setup button
        changeButton.rx.tap.asDriver().drive(onNext: {
            self.viewModel.switchFields()
        }).disposed(by: disposeBag)
        
        //Setup Choose currency button
        
        fromView.currencyButton.rx.tap.asDriver().drive(onNext: {
            let vc = ChooseCurrencyViewController()
            vc.viewModel.type = "from"
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        
        toView.currencyButton.rx.tap.asDriver().drive(onNext: {
            let vc = ChooseCurrencyViewController()
            vc.viewModel.type = "to"
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
   
    }
}

// MARK:  - SETUP UI
extension ExchangeViewController: UITextFieldDelegate {
    private func setupUI() {
        
        //self.backgroundColor = .yellow
        setupChangeButton()
        setupHeader()
        setupFromView()
        setupToView()
    }
    
    private func setupChangeButton() {
        view.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            changeButton.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        view.layoutIfNeeded()
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = Theme.Radius.minimal
        changeButton.backgroundColor = Theme.Color.mainColorPale
        changeButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        changeButton.imageView?.tintColor = Theme.Color.mainColor.withAlphaComponent(0.4)
        changeButton.imageView?.contentMode = .scaleAspectFit

    }
    
    
    
    private func setupHeader() {
        view.addSubview(exchangeLabel)
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            exchangeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.75),
            exchangeLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            exchangeLabel.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor),
        ])
        
        exchangeLabel.text = "Exchange"
        exchangeLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        
        exchangeLabel.adjustsFontSizeToFitWidth = true
        exchangeLabel.textAlignment = .left
        exchangeLabel.textColor = Theme.Color.mainText
        //exchangeLabel.backgroundColor = .white
        
        
    }
    
    private func setupFromView() {
        view.addSubview(fromView)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        fromView.header.text = "From"
        fromView.textField.text = "1"
        
        NSLayoutConstraint.activate([
            fromView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            fromView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fromView.rightAnchor.constraint(equalTo: view.rightAnchor),
            fromView.topAnchor.constraint(equalTo: changeButton.bottomAnchor), // 0.05 of view
        ])
    }
    private func setupToView() {
        view.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        toView.header.text = "To"
        
        NSLayoutConstraint.activate([
            toView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            toView.leftAnchor.constraint(equalTo: view.leftAnchor),
            toView.rightAnchor.constraint(equalTo: view.rightAnchor),
            toView.topAnchor.constraint(equalTo: fromView.bottomAnchor, constant: UIScreen.main.bounds.height*0.0125), // 0.05 of view
        ])
        
        
    }
}
