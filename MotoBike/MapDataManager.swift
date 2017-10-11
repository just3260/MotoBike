//
//  MapDataManager.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/14.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol MapDataDelegate: NSObjectProtocol {
    /// 更新地圖畫面
    func mapRefresh(region: MKCoordinateRegion)
    
    /// 在地圖上插上大頭針
    func addMapPin(annotation: PinData)
    
    /// 在地圖上插上大頭針群組
    func addMapPins(annotations: [PinData])
    
    /// 刪除在地圖上的大頭針群組
    func deleteMapPins(annotations: [PinData])
}

class MapDataManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MapDataDelegate!
    
    /// User 位置管理
    var locationManager = CLLocationManager()
    
    /// 地理編碼加載
    var geoCoder: CLGeocoder = CLGeocoder()
    
    /// 加油站資料群組
    var gasPinArray = [PinData]()
    
    /// 經緯度轉換（TWD097_to_GWS84）
    func TWD097_to_GWS84(point: CGPoint) -> CLLocationCoordinate2D{
        
        var x = Double(point.x)
        var y = Double(point.y)
        
        let a = 6378137.0
        let b = 6356752.314245
        
        let lng0 = 121 * Double.pi / 180
        let k0 = 0.9999
        let dx = 250000.0
        let dy = 0.0
        let e  = pow((1 - pow(b,2) / pow(a,2)) , 0.5)
        x  = x - dx
        y  = y - dy
        let mm = y / k0
        let mu = mm / (a * (1.0 - pow(e,2) / 4.0 - 3 * pow(e,4) / 64.0 - 5 * pow(e,6) / 256.0))
        let e1 = (1.0 - pow((1.0 - pow(e,2)), 0.5)) / (1.0 + pow((1.0 - pow(e,2)) , 0.5))
        let j1 = (3 * e1 / 2 - 27 * pow(e1,3) / 32.0)
        let j2 = (21 * pow(e1,2) / 16 - 55 * pow(e1,4) / 32.0)
        let j3 = (151 * pow(e1,3) / 96.0)
        let j4 = (1097 * pow(e1,4) / 512.0)
        let fp = mu + j1 * sin(2 * mu) + j2 * sin(4 * mu) + j3 * sin(6 * mu) + j4 * sin(8 * mu)
        let e2 = pow((e * a / b) , 2)
        let c1 = pow(e2 * cos(fp) , 2)
        let t1 = pow(tan(fp) , 2)
        let r1 = a * (1 - pow(e , 2)) / pow((1 - pow(e , 2) * pow(sin(fp) , 2)) , (3.0 / 2.0))
        let n1 = a / pow((1 - pow(e , 2) * pow(sin(fp) , 2)) , 0.5)
        
        let dd = x / (n1 * k0)
        let q1 = n1 * tan(fp) / r1
        let q2 = (pow(dd , 2) / 2.0)
        let q3 = (5 + 3 * t1 + 10 * c1 - 4 * pow(c1 , 2) - 9 * e2) * pow(dd , 4) / 24.0
        let q4 = (61 + 90 * t1 + 298 * c1 + 45 * pow(t1 , 2) - 3 * pow(c1 , 2) - 252 * e2) * pow(dd , 6) / 720.0
        var lat = fp - q1 * (q2 - q3 + q4)
        let q5 = dd
        let q6 = (1 + 2 * t1 + c1) * pow(dd , 3) / 6
        let q7 = (5 - 2 * c1 + 28 * t1 - 3 * pow(c1 , 2) + 8 * e2 + 24 * pow(t1 , 2)) * pow(dd , 5) / 120.0
        var lng = lng0 + (q5 - q6 + q7) / cos(fp)
        
        //output WGS84
        lat = (lat * 180) / Double.pi
        lng = (lng * 180) / Double.pi
        
        return CLLocationCoordinate2DMake(lat, lng)
    }
    

    /// locationManager 設定相關
    func locationSetting() -> CLAuthorizationStatus {
        
        // Ask user's permission.
        //        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // Prepare locationManager.
        locationManager.delegate = self
        // 定位的精準度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 移動距離的精準度
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        locationManager.activityType = .automotiveNavigation
        
        // 開始接收目前位置資訊
        locationManager.startUpdatingLocation()
        // 移動十公尺再更新座標
        locationManager.distanceFilter = CLLocationDistance(10)
        
        /// 使用者授權狀態
        let locationManagerStatus = CLLocationManager.authorizationStatus()
        
        return locationManagerStatus
    }
    
    
    // 啟用時定位使用者位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 取得最新位置
        guard let currentLocation = locations.last else {
            return
        }
        let coordinate = currentLocation.coordinate
        //        NSLog("Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
        
        DispatchQueue.once(token: "MoveAndZoomMap") {
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            mapView.mapRefresh(region: region)
        }
        
    }
    
    
    /// 新增大頭針資料
    func addPinData(coordinate: CLLocationCoordinate2D) {
        
        /// 新增大頭針內容
        let annotation = PinData(coordinate:coordinate, title: "錯誤", subtitle: "無法判斷位置")
        annotation.type = .user
        /// 經緯度
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geoCoder.reverseGeocodeLocation(location) { (address:[CLPlacemark]?, error:Error?) in
            
            if error == nil {
                let pinAddress = address?.first
                print(pinAddress ?? "位置判斷錯誤")

                annotation.title = pinAddress?.locality
                annotation.subtitle = pinAddress?.name

                selectPinData.pinMark = pinAddress
            }
        }
        
        mapView.addMapPin(annotation: annotation)
    }
    
    
    /// 將經緯度轉為地址 (因逃逸閉包問題，故不採用此Func)
    func changeCoordinate(coordinate: CLLocationCoordinate2D) {

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geoCoder.reverseGeocodeLocation (location) { (address: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard (address?.first) != nil else {
                    return
                }
            }
        }
    }
    
    
    /// 新增群組大頭針
    func addPinWithDownloadData(array: [AnyObject]) {
        
        for data in array {
            
            guard let name = data["S_NAME"] as? String,
                
            let address = data["ADDRESS"] as? String,
                
            let addressX = data["ADDR_X"] as? String,
                
            let addressY = data["ADDR_Y"] as? String
            
            else {
                return
            }
            

            let x = addressX as NSString
            let y = addressY as NSString
            
            let addrX = x.doubleValue
            let addrY = y.doubleValue

            let TWD97XY = CGPoint(x: addrX, y: addrY)
            let GWS84 = TWD097_to_GWS84(point: TWD97XY)

            // 大頭針內容
            let annotation = PinData(coordinate: GWS84, title: name, subtitle: address)
            annotation.type = .gasStation
//            mapView.addMapPin(annotation: annotation)
            gasPinArray.append(annotation)
        }
        
        mapView.addMapPins(annotations: gasPinArray)
        
    }
    
    
    /// 刪除群組大頭針
    func deleteGasPins() {
        mapView.deleteMapPins(annotations: gasPinArray)
    }



    
}



