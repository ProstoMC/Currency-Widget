//
//  CornersWhiteSegmentedControl.swift
//  Currency Widget
//
//  Created by macSlm on 07.12.2023.
//


// CORNERS DONT WORK!!!!!!!

import UIKit

class CornersWhiteSegmentedControl: UISegmentedControl {

    
    private(set) lazy var radius:CGFloat = bounds.height / 2

    
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.cornerRadius = radius
        //setupCorners()
        clipsToBounds = true
        fixBackgroundSegmentControl(self)
    }
    
    override func draw(_ rect: CGRect) {
        //layer.cornerRadius = radius
        layer.masksToBounds = true
        backgroundColor = .white
        
        selectedSegmentIndex = 0
        layer.backgroundColor = Theme.Color.backgroundForWidgets.cgColor
        selectedSegmentTintColor = Theme.Color.mainColor
        
        let selectedTextColor = [NSAttributedString.Key.foregroundColor: Theme.Color.backgroundForWidgets]
        let normalTextColor = [NSAttributedString.Key.foregroundColor: Theme.Color.mainColor]
        
        setTitleTextAttributes(selectedTextColor, for: .selected)
        setTitleTextAttributes(normalTextColor, for: .normal)
        
    }
    
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    //IT IS DOESNT WORK
    
    func setupCorners() {
        //let selectedImageViewIndex = numberOfSegments
        guard let selectedSegment = subviews[numberOfSegments] as? UIImageView else {
             return
         }
 
         selectedSegment.image = nil
         selectedSegment.backgroundColor = Theme.Color.mainColor
         selectedSegment.layer.removeAnimation(forKey: "SelectionBounds")
         selectedSegment.layer.cornerRadius = radius - layer.borderWidth
         selectedSegment.bounds = CGRect(origin: .zero, size: CGSize(
             width: selectedSegment.bounds.width,
             height: bounds.height - layer.borderWidth * 2
         ))
        layer.backgroundColor = Theme.Color.backgroundForWidgets.cgColor
        
        let backgroundView = subviews[0]
        backgroundView.backgroundColor = Theme.Color.backgroundForWidgets
        
        
    }
    

}
