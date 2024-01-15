//
//  ImageWorker.swift
//  Currency Widget
//
//  Created by macSlm on 12.01.2024.
//

import Foundation
import UIKit
import RxSwift

class RxImageFetcher {
    var rxImage = BehaviorSubject<UIImage?>(value: nil)
    
    func fetchImage(url: String) {
        
        if let imageFromCache = getFromCache(key: url) {
            rxImage.onNext(imageFromCache)
        } else {
            fetchFromEth(url: url, complition: { image in
                self.rxImage.onNext(image)
                self.saveToCache(key: url, image: image)
            })
        }
    }

    
}

extension RxImageFetcher {
    
    private func getFromCache(key: String) -> UIImage? {
        return nil
    }
    
    private func saveToCache(key: String, image: UIImage) {
        
    }
    
    private func fetchFromEth(url: String, complition: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: url) else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            complition(image)
        }.resume()
            
    }
    
    
}
