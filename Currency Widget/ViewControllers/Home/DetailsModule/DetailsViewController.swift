//
//  DetailsViewController.swift
//  Currency Widget
//
//  Created by macSlm on 19.12.2023.
//

import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    
    let bag = DisposeBag()
    let viewModel: DetailsViewModuleProtocol = DetailsViewModule()
    
    let favouriteButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRx()
    }


}

extension DetailsViewController {
    private func setupRx() {
        
        //Appearing of view
        viewModel.rxIsAppearFlag.subscribe { flag in
            self.view.isHidden = !flag
        }.disposed(by: bag)
       
        //Favorite status
        viewModel.rxFavoriteStatus.subscribe{ status in
            if status {
                self.favouriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            }
            else {
                self.favouriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
        }.disposed(by: bag)
        
        favouriteButton.rx.tap.asDriver().drive(onNext: {
            self.viewModel.changeFavoriteStatus()
            CoreWorker.shared.rxExhangeFlag.onNext(true)
        }).disposed(by: bag)
        
        
    }
}
// MARK:  - SETUP UI
extension DetailsViewController {
    private func setupUI() {
        view.isHidden = true
        view.backgroundColor = Theme.Color.backgroundForWidgets
        view.layer.cornerRadius = Theme.Radius.mainWidget
        
        setupFavoriteView()
    }
    
    private func setupFavoriteView(){
        view.addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favouriteButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            favouriteButton.topAnchor.constraint(equalTo: view.topAnchor),
            favouriteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
        
        favouriteButton.tintColor = Theme.Color.mainColor
        self.favouriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        favouriteButton.contentMode = .scaleAspectFit
    }
}
