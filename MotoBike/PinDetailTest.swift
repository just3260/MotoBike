//
//  PinDetailView.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/19.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

class PinDetailTest: UIView {
    
    var aboveView : UIView!
    var informationLabel : UILabel!{
        didSet{
            informationLabel.textAlignment = NSTextAlignment.center
        }
    }
    var informationFont : UIFont! {
        didSet {
            informationLabel.font = informationFont
        }
    }
    var informationColor : UIColor! {
        didSet {
            informationLabel.textColor = informationColor
        }
    }
    
    var topColor : UIColor? {
        didSet {
            aboveView.backgroundColor = topColor
        }
    }
    var bottomColor : UIColor? {
        didSet {
            self.backgroundColor = bottomColor
        }
    }
    
    
    
    /// 能量條現在數值設定
    var value:(current:Int,max:Int)!
    {
        didSet{
            self.totalValue = self.value.max
            self.currentValue = self.value.current
            
            // 讓HP條顯示為紅色
            let barStatus = Double(self.currentValue) / Double(self.totalValue)
            if (barStatus <= 0.3 && self.barColor == 1) {
                self.aboveView.backgroundColor = UIColor(red: 0x240/255, green: 0x65/255, blue: 0x70/255, alpha: 1)
            }
            else if (self.barColor == 1) {
                self.aboveView.backgroundColor = UIColor(red: 0x20/255, green: 0x99/255, blue: 0x25/255, alpha: 1)
            }
        }
    }
    /// 當前能量條數值
    var currentValue :Int! {
        didSet {
            informationLabel.text = "\(currentValue!) / \(totalValue!)"
            updateFrame()
            aboveView.frame.size.width = CGFloat(Double(currentValue) / Double(totalValue)) * self.frame.width
            layoutIfNeeded()
        }
    }
    /// 能量條最大值
    var totalValue : Int! {
        didSet {
            
        }
    }

    /**
     # 能量條顏色
     ````
     barColor = 1時，為HP血量條
     barColor = 2時，為MP魔力條
     barColor = 3時，為HP經驗條
     */
    var barColor: Int!{
        didSet {
            // 1為綠色（HP）
            if(barColor == 1) {
                aboveView.backgroundColor = UIColor(red: 0x20/255, green: 0x99/255, blue: 0x25/255, alpha: 1)
            }
                // 2為藍色（MP）
            else if(barColor == 2) {
                aboveView.backgroundColor = UIColor(red: 0x53/255, green: 0x96/255, blue: 0x240/255, alpha: 1)
            }
                // 3為黃色（EXP）
            else if(barColor == 3) {
                aboveView.backgroundColor = UIColor(red: 0x255/255, green: 0x204/255, blue: 0x57/255, alpha: 0.9)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    /// 設定Bar基礎樣式
    func setup() {
        
        // 將View放至與MapView一樣大
        self.frame = (superview?.frame)!

        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.lightGray
        
        aboveView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
        self.addSubview(aboveView)
        
        informationLabel = UILabel()
        informationLabel.text = "0/0"
        informationLabel.font = UIFont.systemFont(ofSize: 10)
        informationLabel.textColor = UIColor.black
        updateFrame()
        
        aboveView.addSubview(informationLabel)
        layoutIfNeeded()
    }
    
    
    func updateFrame(){
        informationLabel.sizeToFit()
        informationLabel.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    
}

