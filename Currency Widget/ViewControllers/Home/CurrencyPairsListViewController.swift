//
//  TileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit
import RxSwift
import RxDataSources

class CurrencyPairsListViewController: UIViewController {
    
    var viewModel: CurrencyPairsListViewModelProtocol!
    let disposeBug = DisposeBag()
    
    var collectionView: UICollectionView!
    //var data: [Currency] = []
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = UICollectionView.ScrollDirection.horizontal
        return f
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CurrencyPairsListViewModel()
        
        setupUI()
        
//        viewModel = CurrencyListViewModel()
//        viewModel.pairList.bind(
//            to: collectionView.rx.items) { (row, pairList, item) -> Tile1x2CollectionViewCell in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath(row: row, section: 0)) as! Tile1x2CollectionViewCell
//                cell.configure(
//
//                    shortName: data[row].shortName,
//                    logo: data[row].logo,
//                    value: data[row].rate,
//                    base: CurrencyFetcher.shared.baseCurrency.shortName,
//                    baseLogo: CurrencyFetcher.shared.baseCurrency.logo
//                )
//                return cell
//            }.disposed(by: disposeBug)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    
    // MARK: - Collection View Appearing
    private func setupUI() {
        view.backgroundColor = Theme.Color.background
        setupCollectionView()
    }

    private func setupCollectionView(){
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        //Setup space before first element (x2 then between elements)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.bounds.width / 25, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = Theme.Color.background
        
        print("setupCollectionView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(Tile1x2CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        
    }
}

// MARK:  - CollectionView Extensions

extension CurrencyPairsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pairs.count
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height*0.92, height: collectionView.bounds.height) //Size of Tale
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width / 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Tile1x2CollectionViewCell
        print ("cell")
        cell.configureWithPair(
            shortName: viewModel.pairs[indexPath.row].valueCurrencyShortName,
            logo: viewModel.pairs[indexPath.row].baseLogo,
            value: viewModel.pairs[indexPath.row].value,
            base: viewModel.pairs[indexPath.row].baseCurrencyShortName,
            baseLogo: viewModel.pairs[indexPath.row].baseLogo)

        return cell
    }


}
