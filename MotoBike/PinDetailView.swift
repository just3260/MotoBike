//
//  PinDetailView.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/19.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import MapKit
import Foundation


// 擴充UIView功能
extension UIView {
    
    // 連結Stotyboard用
//    @IBInspectable var address: String?
//        {
//        get {
//            return PinAddress.text
//        }
//        set(newTitle){
//            PinAddress.text = newTitle
//        }
//    }

//    @IBInspectable var image: UIImage?
//        {
//        get {
//            return PinImage.image
//        }
//        set(newImage) {
//            PinImage.image = newImage
//        }
//    }
    
    @IBInspectable var cornerRadiu: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @discardableResult func addRightBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(layer)
        return self
    }
    
    @discardableResult func addLeftBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(layer)
        return self
    }
    
    @discardableResult func addTopBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
        return self
    }
    
    @discardableResult func addBottomBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
        return self
    }
    
    

}


@IBDesignable class PinDetailView: UIView {
    
    @IBOutlet fileprivate var PinDetailView: UIView!
    
    @IBOutlet fileprivate weak var RectangularView: UIView!
    
    @IBOutlet fileprivate weak var PinType: UILabel!
    
    @IBOutlet fileprivate weak var PinAddress: UILabel!
    
    @IBOutlet fileprivate weak var PinImage: UIImageView!

    @IBOutlet fileprivate weak var confirmView: UIView!
    
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var condition: UILabel!
    
    @IBOutlet weak var stepsOutlet: UIButton!
    
    @IBOutlet weak var routeOutlet: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // 初始化
    func initFromXIB() {
        // 將View放至與螢幕尺寸一樣大
        self.frame = UIScreen.main.bounds
        // 將背景色透明度改為0
        self.backgroundColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PinDetailView", bundle: bundle)
        PinDetailView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        PinDetailView.frame = bounds
        PinDetailView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)   // 置中
        self.addSubview(PinDetailView)
        
        PinDetailView.addSubview(RectangularView)
        
        makeShadow(targetView: RectangularView)
        makeShadow(targetView: confirmView)
        
        refreshPinData()
        
        RectangularView.addSubview(PinAddress)
        RectangularView.addSubview(PinType)
        RectangularView.addSubview(PinImage)
        
        let borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        stepsOutlet.addTopBorder(color: borderColor, width: 2.0)
        stepsOutlet.addRightBorder(color: borderColor, width: 1.0)
        routeOutlet.addTopBorder(color: borderColor, width: 2.0)
        routeOutlet.addLeftBorder(color: borderColor, width: 1.0)
        
    }

    
    
    /// 確認按鈕
    @IBAction func confirmBtn(_ sender: Any) {
        
        // 消失動畫
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (PinDetailView) in
                self.isHidden = true
            })
            
        })
    }
    
    
    /// 路線規劃按鈕
    @IBAction func routeBtn(_ sender: Any) {
        
        guard let targetPlaceMark = selectPinData.pinMark else {
            return
        }
        
        let directionRequest = MKDirectionsRequest()
        // 設定路徑起始與目的地
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: targetPlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = MKDirectionsTransportType.automobile
        
        // 方位計算
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate(completionHandler: { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            selectPinData.route = route
            
            let routeNotification = Notification.Name(rawValue:"ADDROUTE")
            NotificationCenter.default.post(name: routeNotification, object: nil, userInfo: nil)
        })
        
        confirmBtn(self)
    }
    

    /// 顯示steps路線畫面
    @IBAction func stepsBtn(_ sender: Any) {
        let routeNotification = Notification.Name(rawValue:"STEPSBTN")
        NotificationCenter.default.post(name: routeNotification, object: nil, userInfo: nil)
        
        confirmBtn(self)
    }
    
    
    
    /// 將大頭針資料寫入View
    func refreshPinData() {
        
        let pinData = selectPinData.pinDetailData
        guard pinData != nil else {
            return
        }
        
        PinAddress.text = (pinData?.annotation?.subtitle)!
        PinType.text = (pinData?.annotation?.title)!
        PinImage.image = UIImage(named: "pin")
        weather.text = "無天氣資訊"
        condition.text = "無路況資訊"
        
        for gasPin in selectPinData.gasStationArray {
            if let address = pinData?.annotation?.subtitle {
                if address == gasPin.subtitle {
                    PinImage.image = UIImage(named: "gas station")
                    return
                }
            }
        }
        
        for parkingPin in selectPinData.parkingArray {
            if let address = pinData?.annotation?.subtitle {
                if address == parkingPin.subtitle {
                    PinImage.image = UIImage(named: "parkingPin")
                    return
                }
            }
        }
        
        switch selectPinData.postData[0] {
        case "晴天地乾":
            weather.text = "天氣狀況：☀️"
        case "陰天有雲":
            weather.text = "天氣狀況：☁️"
        case "雨天地濕":
            weather.text = "天氣狀況：🌧"
        default:
            weather.text = "無天氣資訊"
        }
        
        switch selectPinData.postData[1] {
        case "正常行駛":
            condition.text = "路況：👍"
        case "注意危險":
            condition.text = "路況：⚠️"
        case "禁止通行":
            condition.text = "路況：⛔️"
        default:
            condition.text = "無路況資訊"
        }
        
        PinType.text = selectPinData.postData[2]

    }
    
    
    /// 製作陰影
    func makeShadow(targetView: UIView) {
        
        targetView.layer.masksToBounds = false
        targetView.layer.shadowOffset = CGSize(width: 5, height: 5)
        targetView.layer.shadowOpacity = 0.7
        targetView.layer.shadowRadius = 5
        targetView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    }
    
    
    /// 製作邊框
    func makeBorder(targetView: UIView, color: CGColor, width: CGFloat) {
        
        targetView.layer.borderColor = color
        targetView.layer.borderWidth = width
    }


    
}
