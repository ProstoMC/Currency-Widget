//
//  TileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// MARK:  - Setup sections for RxDataSource

struct SectionOfCustomData {
  var header: String
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = CurrencyPair

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

// MARK:  ViewController

class CurrencyPairsListViewController: UIViewController {
    
    var collectionView: UICollectionView!
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = UICollectionView.ScrollDirection.horizontal
        return f
    }()
    
    var viewModel: CurrencyPairsListViewModelProtocol!
    let disposeBug = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrencyPairsListViewModel()
        
        setupUI()
        bindCollectionView()
    }
    
    private func bindCollectionView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Tile1x2CollectionViewCell
              cell.rxConfigure(currecnyPair: item)
              
            return cell
        })
        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
            return true
            
        }
        
        viewModel.rxPairList.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBug)
        
        collectionView.rx.modelSelected(CurrencyPair.self).subscribe(onNext: {_ in
            print ("SELECTED")
            self.viewModel.addCell()
        }).disposed(by: disposeBug)
        
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

// MARK:  - CollectionView Appearing

extension CurrencyPairsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height*0.92, height: collectionView.bounds.height) //Size of Tale
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width / 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
