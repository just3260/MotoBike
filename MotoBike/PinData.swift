//
//  MapManager.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/13.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation
import MapKit

struct selectPinData {
    
    /// 選取到的大頭針資料
    static var pinDetailData: MKAnnotationView!
    
    /// 大頭針標記資料
    static var pinMark: CLPlacemark!
    
    /// 路徑資料
    static var route: MKRoute!
    
    /// 儲存加油站資料
    static var gasStationArray = [PinData]()
    
    /// 儲存停車場資料
    static var parkingArray = [PinData]()
    static var allParkingArray = [[String : String]]()
    
    /// 呼叫地址方法
    static func getAddress() -> String {
        
        let fail = "定位失敗"
        guard self.pinMark != nil else {
            return fail
        }
        
        guard let address = self.pinMark.name else {
            return fail
        }
        return address
    }
}

    // pinMark 內容
//name         街道地址
//country      國家
//province     省
//locality     市
//sublocality  縣.區
//route        街道、路
//streetNumber 門牌號碼
//postalCode   郵遞區號


    // MKAnnotationView 內容
// coordinate : 經緯度信息
// altitude : 海拔
// horizontalAccuracy : 水平精確度,如果為負數,代表位置不可用,
// verticalAccuracy : 垂直精確度,如果為負數,代表海拔不可用
// course : 航向,如果為負數,代表航向不可用
// speed : 速度,如果為負數,代表速度不可用
// timestamp : 獲取當前定位到的時間
// distance(from location: CLLocation) : 計算2個位置之間的實際物理距離

enum pinType {
    case user
    case gasStation
    case parking

}

class PinData: NSObject, MKAnnotation {
    
    /// 大頭針的經緯度
    var coordinate: CLLocationCoordinate2D
    
    /// 大頭針所在區域
    var title: String?
    
    /// 大頭針所在地址
    var subtitle: String?
    
    /// 大頭針類型
    var type: pinType = .user
    
    // 初始化
    init(coordinate:CLLocationCoordinate2D!, title:String?, subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}



public class PinAnnotation: MKAnnotationView  {
    
    /// iConView
    var iconImageView: UIImageView!
    /// 底圖
    var DrawView:UIView!
    /// 大頭針類型
    var type: pinType = pinType.user
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // 新增圖層
        iconImageView = UIImageView()
        // 主圖層
        DrawView = UIView()
        DrawView.addSubview(iconImageView)
        
        self.addSubview(DrawView)
    }
    
    public required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame);
//    }
    
    
    /// 製作地圖圖標
    public func DrawCustomerView(){
      
        // 圖層框架
        iconImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 35)
//        iconImageView.layer.cornerRadius = 3
        
        switch self.type {
        case .user:
            iconImageView.image = UIImage(named: "pin")
        case .gasStation:
            iconImageView.image = UIImage(named: "gas station")
        case .parking:
            iconImageView.image = UIImage(named: "parkingPin")
        }
        
        self.frame = CGRect(x: 0, y: 0, width: iconImageView.frame.width, height: iconImageView.frame.height)
        self.centerOffset = CGPoint(x: 0, y: -12)
    }
}

