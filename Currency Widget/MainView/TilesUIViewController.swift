//
//  TileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit

class TilesUIViewController: UIViewController {
    
    let headView = UIView()
    let addView = AddTileUIView()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = UICollectionView.ScrollDirection.horizontal
        return f
    }()
    
    var collectionView: UICollectionView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
        setup()
    }
    
    private func setup() {
        view.backgroundColor = Theme.Color.background
        setupHeadView()
        setupAddView()
        setupCollectionView()
    }
    
    private func setupHeadView() {
        headView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headView)
        
        NSLayoutConstraint.activate([
            headView.topAnchor.constraint(equalTo: view.topAnchor),
            headView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.125)
        ])
        
        headView.backgroundColor = .gray
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
    
    private func setupCollectionView(){
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        print("setupCollectionView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cell = UICollectionViewCell()
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        //collectionView.bounces = true
        collectionView.backgroundColor = Theme.Color.background
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        
    }
}

extension TilesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.height/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        print(indexPath.row)
        
        let view = AddTileUIView()
        cell.contentView.addSubview(view)
        view.frame = cell.bounds
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.gray.cgColor

        return cell
    }
    
    
}
