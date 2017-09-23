//
//  DesignCardView.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/16.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

@IBDesignable class DesignCardView: UIView {
    
    @IBInspectable var cardViewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
            
        }
        
        set {
            return layer.cornerRadius = newValue
            
        }
        
    }
    
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    
    @IBInspectable var shadowoffSetWidth: Int {
        get {
            return Int(layer.shadowOffset.width)
            
        }
        
        set {
            return layer.shadowOffset.width = CGFloat(newValue)
            
        }
        
    }
    
    @IBInspectable var shadowoffSetHeight: Int {
        get {
            return Int(layer.shadowOffset.height)
            
        }
        
        set {
            return layer.shadowOffset.height = CGFloat(Int(newValue))
            
        }
        
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
            
        }
        
        set {
            return layer.shadowOpacity = newValue
            
        }
        
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = cardViewCornerRadius

        layer.shadowColor = shadowColor?.cgColor

        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardViewCornerRadius)

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


