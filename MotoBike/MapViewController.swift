//
//  MapViewController.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/12.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import InteractiveSideMenu

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MapDataDelegate, SideMenuItemContent {
    
    /// 主地圖畫面
    @IBOutlet weak var mainMapView: MKMapView!
    /// 個人資料按鈕
    @IBOutlet weak var userDataOutlet: UIButton!
    /// 大頭針詳細資料
    @IBOutlet weak var pinDetailView: PinDetailView!
    
    /// 地圖管理員
    let mapManager = MapDataManager()
    /// 長按手勢
    var longPressGesture: UILongPressGestureRecognizer!
    /// 大頭針鎖（防止重複插針）
    var addPinLock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.mapView = self
        mainMapView.delegate = self
        
        // 隱藏PinDetailView
        pinDetailView.isHidden = true
        pinDetailView.alpha = 0.0
        
        // 長按手勢動作
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addNewMapEvent))
        longPressGesture.minimumPressDuration = 1.0
        self.mainMapView.addGestureRecognizer(longPressGesture)
        
        // 接受畫路徑圖通知
        NotificationCenter.default.addObserver(self, selector: #selector(addRoute), name: NSNotification.Name(rawValue: "ADDROUTE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stepsBtnTap), name: NSNotification.Name(rawValue: "STEPSBTN"), object: nil)
        
    }
    
    // 螢幕消失時，關閉定位功能（省電）
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        // 背景執行時關閉定位功能
        mapManager.locationManager.stopUpdatingLocation()
    }
    
    
    // 載入地圖完成時，移到當前位置
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let status = mapManager.locationSetting()
        // 判斷使用者是否有同意App使用位置訊息，有的話即顯示當前位置
        if status == CLAuthorizationStatus.authorizedAlways {
            mainMapView.showsUserLocation = true
        }
    }
    
    
    
    // MARK: - Functions
    
    // 選取到大頭針時動作
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let address = view.annotation?.subtitle,
            address != nil else {
                print("error：address = nil")
                return
        }
        
        // 將將大頭針資料暫存
        selectPinData.pinDetailData = view
        
        pinDetailView.refreshPinData()
        
        print("點擊的位置為：\(address!)")
        pinDetailView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.pinDetailView.alpha = 1.0
        })
        
    }
    /// 長按時在地圖上新增事件
    func addNewMapEvent(sender: UIGestureRecognizer) {
        
        if addPinLock.try() == false {
            if sender.state == .ended {
                addPinLock.unlock()
                print("addPinLock key unlock!")
            }
            return
        }

        // 取得螢幕點擊位置
        let touchPoint = longPressGesture.location(in: mainMapView)
        // 轉換為經緯度
        let touchCoordinate = mainMapView.convert(touchPoint, toCoordinateFrom: mainMapView)
        
        mapManager.addPinData(coordinate: touchCoordinate)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (MapViewController) in
            // 跳轉至Post畫面
            let postView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewPostViewController")
            postView.modalTransitionStyle = .crossDissolve
            self.present(postView, animated: true, completion: nil)
        }
        
    }
    
    
    // 在地圖上畫出路徑
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    /// 路線規劃
    func addRoute() {
        
        guard let route = selectPinData.route else {
            print("nil")
            return
        }
        self.mainMapView.removeOverlays(self.mainMapView.overlays)
        self.mainMapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        
        let rect = route.polyline.boundingMapRect
        self.mainMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
    }
    
    
    // 在地圖上插大頭針
    func mapView(_ mainMapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation is MKUserLocation){
            // return nil表示用預設值那個藍色發光圓形圖
            return nil
        }
        
        var pin: PinAnnotation? = mainMapView.dequeueReusableAnnotationView(withIdentifier: "UserAddPoint") as? PinAnnotation
        
        if(pin == nil){
            pin = PinAnnotation(annotation: annotation, reuseIdentifier: "UserAddPoint")
            // 關閉大頭針詳細資料
            pin?.canShowCallout = false
            
        }
        pin?.DrawCustomerView()
        pin?.annotation = annotation
        return pin
    }
    
    
    // 新增大頭針時呼叫的方法(動畫)
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        if views.last?.annotation is MKUserLocation {
            // 關閉userLocation資訊
            views.last?.canShowCallout = false
            return
        }

        
        let visibleRect = mapView.annotationVisibleRect
        
        for view:MKAnnotationView in views{
            let endFrame:CGRect = view.frame
            var startFrame:CGRect = endFrame
            startFrame.origin.y = visibleRect.origin.y - startFrame.size.height
            view.frame = startFrame
            
            UIView.beginAnimations("drop", context: nil)
            UIView.setAnimationDuration(0.5)
            
            view.frame = endFrame
            
            UIView.commitAnimations()
        }
    }
    
    // 定位失敗時
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败：\(error)")
    }
    
    // MARK: - Delegate Function
    
    // 更新地圖畫面
    func mapRefresh(region: MKCoordinateRegion) {
        mainMapView.setRegion(region, animated: false)
    }
    
    
    // 在地圖上插上大頭針
    func addMapPin(annotation: PinData) {
        mainMapView.addAnnotation(annotation)
    }
    
    

    
    // MARK: - 螢幕按鈕
    /// 在地圖上新增標籤
    @IBAction func addNewEvent(_ sender: Any) {
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (MapViewController) in
            // 跳轉至Post畫面
            let postView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController")
            postView.modalTransitionStyle = .crossDissolve
            self.present(postView, animated: true, completion: nil)
        }
        
        // 在當前位置新增大頭針
        guard let userCoordinate = mapManager.locationManager.location?.coordinate else {
            return
        }
        
        mapManager.addPinData(coordinate: userCoordinate)
        
    }
    
    
    /// 使用者定位按鈕
    @IBAction func userTrackingModeChanged(_ sender: Any) {
        
        if mainMapView.userTrackingMode != .follow {
            mainMapView.userTrackingMode = .follow
        } else  {
            mainMapView.userTrackingMode = .followWithHeading
        }
    }
    
    
    /// 跳轉至個人資料畫面
    @IBAction func userDataView(_ sender: Any) {
        
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FBLoginViewController") as! FBLoginViewController
        loginView.modalTransitionStyle = .crossDissolve
        present(loginView, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 使用 segue.destinationViewController 來取得新的視圖控制器
        // 傳遞所選的物件至新的視圖控制器
        if segue.identifier == "showSteps" {
            let routeTableViewController = segue.destination.childViewControllers[0] as! RouteTableViewController
            if let steps = selectPinData.route?.steps {
                routeTableViewController.routeSteps = steps
            }
        }
    }

    /// 顯示路徑按鈕
    func stepsBtnTap() {
        performSegue(withIdentifier: "showSteps", sender: view)
    }
    
    
    /// 側邊欄按鈕
    @IBAction func menuBtn(_ sender: UIButton) {
        showSideMenu()
    }
    
    
    
    
    
    
}
