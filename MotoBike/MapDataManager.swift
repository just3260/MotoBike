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
    
    
}

class MapDataManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MapDataDelegate!
    
    /// User 位置管理
    var locationManager = CLLocationManager()
    
    /// 地理編碼加載
    var geoCoder: CLGeocoder = CLGeocoder()

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
//        changeCoordinate(coordinate: coordinate)
        
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
    
    


    
}



