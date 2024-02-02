//
//  CornersWhiteSegmentedControl.swift
//  Currency Widget
//
//  Created by macSlm on 07.12.2023.
//



import UIKit

class CornersWhiteSegmentedControl: UISegmentedControl {
  
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
        //backgroundColor = .white
        //configureColors()
        
        selectedSegmentIndex = 0
    }
    
    func configureColors(
        backgroundColor: UIColor, segmentColor: UIColor, selectedTextColor: UIColor, secondTextColor: UIColor){

        self.backgroundColor = backgroundColor

        selectedSegmentTintColor = segmentColor

        let selectedTextColor = [NSAttributedString.Key.foregroundColor: selectedTextColor]
        let secondTextColor = [NSAttributedString.Key.foregroundColor: secondTextColor]

        setTitleTextAttributes(selectedTextColor, for: .selected)
        setTitleTextAttributes(secondTextColor, for: .normal)
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

}
