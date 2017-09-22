//
//  DesignCardView.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/16.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

@IBDesignable class DesignCardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    
    @IBInspectable let shadowoffSetWidth: Int = 0
    
    @IBInspectable let shadowOffSetHeight: Int = 1
    
    @IBInspectable var shadowOpacity: Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        
        layer.shadowColor = shadowColor?.cgColor
        
        layer.shadowOffset = CGSize(width: shadowoffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = shadowOpacity
        
    }
    
}
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


