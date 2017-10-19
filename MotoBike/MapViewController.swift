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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MapDataDelegate, SideMenuItemContent, URLSessionDelegate, URLSessionDownloadDelegate {
    
    /// 主地圖畫面
    @IBOutlet weak var mainMapView: MKMapView!
    /// 大頭針詳細資料
    @IBOutlet weak var pinDetailView: PinDetailView!
    
    /// 地圖管理員
    let mapManager = MapDataManager()
    /// 長按手勢
    var longPressGesture: UILongPressGestureRecognizer!
    /// 大頭針鎖（防止重複插針）
    var addPinLock = NSLock()
    /// 儲存加油站資料
    var gasStationArray = [AnyObject]()
    /// 暫存點擊的經緯度
    var pressLocation: CLLocationCoordinate2D!
    /// 暫存停車場資料
    var parkingPinArray = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.mapView = self
        mainMapView.delegate = self
        
        // 隱藏PinDetailView
        pinDetailView.isHidden = true
        pinDetailView.alpha = 0.0
        
        // 長按手勢動作
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addNewMapEvent))
        longPressGesture.minimumPressDuration = 0.5
        self.mainMapView.addGestureRecognizer(longPressGesture)
        
        // 接受畫路徑圖通知
        NotificationCenter.default.addObserver(self, selector: #selector(addRoute), name: NSNotification.Name(rawValue: "ADDROUTE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stepsBtnTap), name: NSNotification.Name(rawValue: "STEPSBTN"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stepsBtnTap), name: NSNotification.Name(rawValue: "ADDNEWPOST"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openGasStationPin), name: NSNotification.Name(rawValue: "GASON"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeGasStationPin), name: NSNotification.Name(rawValue: "GASOFF"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openParkingPin), name: NSNotification.Name(rawValue: "PARKINGON"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeParkingPin), name: NSNotification.Name(rawValue: "PARKINGOFF"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNewMapEventDone), name: NSNotification.Name(rawValue: "ADDNEWEVENT"), object: nil)
        
        let dataManager = MBPhPDataManager()
        dataManager.getPHPData(allPHPURL: URL_SELECT_ALL_INFO)
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
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse{
            mainMapView.showsUserLocation = true
        } else {
            let alertController = UIAlertController(title: "警告", message: "沒有同意App使用位置", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title:"確定",style: .default, handler: nil))
            present(alertController, animated: true,completion: nil)
        }
    }
    
    
    // 下載url完成時
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            //JSON資料處理
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location) as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:[String:AnyObject]]
            
            print(dataDic)
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            gasStationArray = dataDic["result"]!["results"] as! [AnyObject]
            
            print("加油站資料下載成功")
            mapManager.addPinWithDownloadData(array: gasStationArray)
            
        } catch {
            print("Error!")
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
        
        guard let coordinate = view.annotation?.coordinate else {
            return
        }
        _ = mapManager.decodeCoordinateToAddress(coordinate: coordinate)
        
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
        
        _ = mapManager.decodeCoordinateToAddress(coordinate: touchCoordinate)
        pressLocation = touchCoordinate
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (MapViewController) in
            // 跳轉至Post畫面
            let postView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewPostViewController")
            postView.modalTransitionStyle = .crossDissolve
            self.present(postView, animated: true, completion: nil)
        }
        
    }
    
    
    /// 確認新增事件
    func addNewMapEventDone() {
        guard let location = pressLocation else {
            return
        }
        mapManager.addPinData(coordinate: location)
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

        var pin: PinAnnotation?  = mainMapView.dequeueReusableAnnotationView(withIdentifier: "pinID") as? PinAnnotation
        pin?.type = .user
        
        if(pin == nil){
            pin = PinAnnotation(annotation: annotation, reuseIdentifier: "pinID")
            // 關閉大頭針詳細資料
            pin?.canShowCallout = false
        }
        
        for gasPin in mapManager.gasPinArray {
            if let viewAddress = annotation.subtitle as? String {
                if gasPin.subtitle == viewAddress {
                    pin?.type = .gasStation
                }
            }
        }
        
        for parkingPin in selectPinData.parkingArray {
            if let viewAddress = annotation.subtitle as? String {
                if parkingPin.subtitle == viewAddress {
                    pin?.type = .parking
                }
            }
        }

        pin?.DrawCustomerView()
        pin?.annotation = annotation
        return pin
    }

    
    
    
    // 新增大頭針時呼叫的方法(動畫)
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {

        let visibleRect = mapView.annotationVisibleRect
        var allAddress = [String]()
        // 抓出所有的停車場地址
        for parkingPin in selectPinData.parkingArray {
            guard let address = parkingPin.subtitle else {
                continue
            }
            allAddress.append(address)
        }
        // 抓出所有的加油站地址
        for parkingPin in mapManager.gasPinArray {
            guard let address = parkingPin.subtitle else {
                continue
            }
            allAddress.append(address)
        }
        
        for view:MKAnnotationView in views{
            
            var pinAnimation = true
            // 避開UserLocation
            if view.annotation is MKUserLocation {
                continue
            }

            let viewAddress = view.annotation?.subtitle as? String
            
            for address in allAddress {
                if viewAddress == address {
                    pinAnimation = false
                }
            }
            // 掉落動畫
            if pinAnimation {
                let endFrame:CGRect = view.frame
                var startFrame:CGRect = endFrame
                startFrame.origin.y = visibleRect.origin.y - startFrame.size.height
                view.frame = startFrame
                
                UIView.beginAnimations("drop", context: nil)
                UIView.setAnimationDuration(1.0)
                
                view.frame = endFrame
                UIView.commitAnimations()
            }

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
    

    // 在地圖上插上大頭針群組
    func addMapPins(annotations: [PinData]) {
        mainMapView.addAnnotations(annotations)
    }

    
    // 刪除在地圖上的大頭針群組
    func deleteMapPins(annotations: [PinData]) {
        mainMapView.removeAnnotations(annotations)
    }
    
    
    /// 啟用加油站大頭針
    func openGasStationPin() {
        print("啟用加油站大頭針")
        // 取得加油站公開資料
        let urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a8fd6811-ab29-40dd-9b92-383e8ebd2a4e"
        guard let url = URL(string: urlString) else {
            NSLog("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error == nil {
                let urlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(urlContent as Any)
                
                guard data != nil else {
                    print("No data was returned by the request!")
                    return
                }
            }
        }
        task.resume()
        
        //建立一般的session設定
        let sessionWithConfigure = URLSessionConfiguration.default
        //設定委任對象為自己
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        //設定下載網址
        let dataTask = session.downloadTask(with: url)
        //啟動或重新啟動下載動作
        dataTask.resume()
        
    }
    
    
    /// 關閉加油站大頭針
    func closeGasStationPin() {
        mapManager.deleteGasPins()
    }
    
    
    /// 啟用停車場大頭針
    func openParkingPin() {
        mapManager.decodeParkingData()
        let parkingPin = selectPinData.parkingArray
        mainMapView.addAnnotations(parkingPin)
    }
    
    
    /// 關閉停車場大頭針
    func closeParkingPin() {
        let parkingPin = selectPinData.parkingArray
        mainMapView.removeAnnotations(parkingPin)
        selectPinData.parkingArray = [PinData]()
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
        
        _ = mapManager.decodeCoordinateToAddress(coordinate: userCoordinate)
        pressLocation = userCoordinate
        
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
    func userDataView() {
        
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
