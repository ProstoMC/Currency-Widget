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
  typealias Item = CurrencyPairCellModel

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
    let bag = DisposeBag()
    
    var movingIndexFrom = 0
    var movingIndexTo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrencyPairsListViewModel()

        setupUI()
        subscribing()
    }
    
    //For reordering cells
    @objc private func handleLongPressGR(gesture: UILongPressGestureRecognizer){
        
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            movingIndexFrom = selectedIndexPath.row
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            if let endedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)){
                movingIndexTo = endedIndexPath.row
            } else {
                movingIndexTo = movingIndexFrom
            }
            collectionView.endInteractiveMovement()
            print ("\(movingIndexFrom) -> \(movingIndexTo)")
            viewModel.reorderPair(fromIndex: movingIndexFrom, toIndex: movingIndexTo)
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func subscribing() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CurrencyPairCell
              cell.rxConfigure(currecnyPair: item, colors: self.viewModel.colorSet)
              
     
            return cell
        })
        
        viewModel.rxPairList.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        collectionView.rx.modelSelected(CurrencyPairCellModel.self).subscribe(onNext: { item in
            self.viewModel.selectTail(pair: item)
            
        }).disposed(by: bag)
        
        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
            //For reordering cells
            return true
        }
        
        viewModel.rxAppThemeUpdated.subscribe(onNext: { flag in
            if flag {
                self.updateColors()
            }
        }).disposed(by: bag)
      
    }

    
    // MARK: - Collection View Appearing
    private func setupUI() {
        
        setupCollectionView()
        updateColors()
    }
    
    private func updateColors() {
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       options: [.allowUserInteraction], animations: { () -> Void in
            self.view.backgroundColor = self.viewModel.colorSet.background
            self.collectionView.backgroundColor = self.viewModel.colorSet.background
        })
    }

    private func setupCollectionView(){
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        //Setup space before first element (x2 then between elements)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.bounds.width / 25, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        
        
        collectionView.delegate = self
        
        collectionView.register(CurrencyPairCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        //For reordering cells
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGR(gesture:)))
        collectionView.addGestureRecognizer(longPressGR)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CurrencyPairCell {
           
            cell.contentView.backgroundColor = viewModel.colorSet.mainColorPale
            UIView.animate(withDuration: 1.0, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                cell.contentView.backgroundColor = self.viewModel.colorSet.backgroundForWidgets
            })
        }
    }
    
}

