//
//  TileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit

class TilesUIViewController: UIViewController {
    
    let header = UIView()
    let addView = AddTileUIView()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = UICollectionView.ScrollDirection.horizontal
        return f
    }()
    
    var collectionView: UICollectionView!
    
    var data: [Currency] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    private func setup() {
        view.backgroundColor = Theme.Color.background
        //setupHeader()
        //setupAddView()
        setupCollectionView()
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leftAnchor.constraint(equalTo: view.leftAnchor),
            header.rightAnchor.constraint(equalTo: view.rightAnchor),
            header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.125)
        ])
        
        header.backgroundColor = Theme.Color.background
        header.layer.borderWidth = 1
        header.layer.borderColor = Theme.Color.border.cgColor
        
    }
    
    private func setupAddView() {
        addView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addView)
        
        NSLayoutConstraint.activate([
            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            addView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
        
    }
    // MARK: - Collection View Appearing
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

extension TilesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
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
        
        cell.configure(
            shortName: data[indexPath.row].shortName,
            logo: data[indexPath.row].logo,
            value: data[indexPath.row].rate,
            base: CurrencyFetcher.shared.baseCurrency.shortName,
            baseLogo: CurrencyFetcher.shared.baseCurrency.logo
        )


        return cell
    }
    
    
}
