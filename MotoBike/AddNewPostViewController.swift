//
//  AddNewPostViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/14.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import Photos
import InteractiveSideMenu

class AddNewPostNavigationViewController: UINavigationController, SideMenuItemContent {
}


class AddNewPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FinPostViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SideMenuItemContent {
    
    @IBOutlet weak var pickerItemLabel: UILabel!
    
    @IBOutlet weak var areaLocation: UITextField!
    
    @IBOutlet weak var upDatePic: UIImageView!
    
    var AddFinPostViewModel = PostViewDataManager()
    
    let PinModel = selectPinData()
    
    let areaTagArray = ["無路況", "北北基路況", "桃竹苗路況", "中彰投路況", "雲嘉南路況", "高高屏路況", "車聚與揪跑", "協助與求救"]
    
    var locationInput = ""
    
    let imgPicker = UIImagePickerController()
    
    var photoArray = [String]()
    
    var MBPhPData = MBPhPDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AddFinPostViewModel.getPostItem = self
        
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
        getselectPinDataAddress()
        
        imgPicker.delegate = self
        
        let imgPost = UITapGestureRecognizer(target: self, action: #selector(getimgTap(gesture:)))
        
        upDatePic.isUserInteractionEnabled = true
        
        upDatePic.addGestureRecognizer(imgPost)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Sunny(_ sender: UIButton) {
        let sun = "晴天地乾"
        
        AddFinPostViewModel.weather.removeAll()
        
        AddFinPostViewModel.weather.append(sun)
        
        print(AddFinPostViewModel.weather)
        
        MBPhPData.getPHPData(allPHPURL: URL_SELECT_ONE_INFO)
        
    }
    
    @IBAction func overcastCloudy(_ sender: UIButton) {
        let cloudy = "陰天有雲"
        
        AddFinPostViewModel.weather.removeAll()
        
        AddFinPostViewModel.weather.append(cloudy)
        
        print(AddFinPostViewModel.weather)
        
    }
    
    @IBAction func rainny(_ sender: UIButton) {
        let rain = "雨天地濕"
        
        AddFinPostViewModel.weather.removeAll()
        
        AddFinPostViewModel.weather.append(rain)
        
        print(AddFinPostViewModel.weather)
        
    }
    
    @IBAction func normalDriving(_ sender: UIButton) {
        let normal = "正常行駛"
        
        AddFinPostViewModel.traffic.removeAll()
        
        AddFinPostViewModel.traffic.append(normal)
        
        print(AddFinPostViewModel.traffic)
        
    }
    
    @IBAction func takeDanger(_ sender: UIButton) {
        let danger = "注意危險"
        
        AddFinPostViewModel.traffic.removeAll()
        
        AddFinPostViewModel.traffic.append(danger)
        
        print(AddFinPostViewModel.traffic)
        
    }
    
    @IBAction func noPassing(_ sender: UIButton) {
        let stop = "禁止通行"
        
        AddFinPostViewModel.traffic.removeAll()
        
        AddFinPostViewModel.traffic.append(stop)
        
        print(AddFinPostViewModel.traffic)
        
    }
    
    @IBAction func areaTag(_ sender: UIButton) {
         getPickerView()
        
    }
    
    @IBAction func confirmLocation(_ sender: UIButton) {
        getselectPinDataAddress()
        
    }
    
    @IBAction func FinPostViewBarBtn(_ sender: UIBarButtonItem) {
        if(AddFinPostViewModel.decideTag.isEmpty) {
            AddFinPostViewModel.decideTag = areaTagArray[0]
            
        }
        
        if(AddFinPostViewModel.location.isEmpty) {
            AddFinPostViewModel.location = "無地址"
            
        }else if(areaLocation.text != selectPinData.getAddress()) {
            locationInput = areaLocation.text!
            
            AddFinPostViewModel.location = locationInput
            
        }
        
        AddFinPostViewModel.getPostViewData()
        
        print(AddFinPostViewModel.postItem)
        
        let PostVC = self.storyboard?.instantiateViewController(withIdentifier: "PostNewsViewController") as! PostNewsViewController
        
        PostVC.PostData = AddFinPostViewModel.postItem
        
        self.present(PostVC, animated: true, completion: nil)
        
    }
    
    @IBAction func CancelPostViewBtn(_ sender: UIBarButtonItem) {
        AddFinPostViewModel.postItem.removeAll()
        
        self.modalTransitionStyle = .crossDissolve
        dismiss(animated: true, completion: nil)
        
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    
    func getPickerView() {
        let areaTagVC = UIViewController()
        
        areaTagVC.preferredContentSize = CGSize(width: 250, height: 250)
        
        let areaPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        
        areaPickerView.delegate = self
        
        areaPickerView.dataSource = self
        
        areaTagVC.view.addSubview(areaPickerView)
        
        let editAreaTagAlert = UIAlertController(title: "選擇地區", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        editAreaTagAlert.setValue(areaTagVC, forKey: "contentViewController")
        
        editAreaTagAlert.addAction(okAction)
        
        present(editAreaTagAlert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return areaTagArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areaTagArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AddFinPostViewModel.decideTag = areaTagArray[row]
        
        pickerItemLabel.text = AddFinPostViewModel.decideTag
        
        print(AddFinPostViewModel.decideTag)
        
    }
    
    func getselectPinDataAddress() {
        if(areaLocation.text == nil) {
            AddFinPostViewModel.location = "無地址"
            
            print("areaLocation is nil")
            
        }else {
            areaLocation.text = selectPinData.getAddress()
            
            locationInput = areaLocation.text!
            
            AddFinPostViewModel.location = locationInput
            
            print(locationInput)
   
        }
        
    }
    
    func getimgTap(gesture: UITapGestureRecognizer) {
        openActionSheet()
        
    }
    
    func openActionSheet() {
        let imgPickerAlert = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        imgPickerAlert.addAction(cameraAction)
        
        imgPickerAlert.addAction(galleryAction)
        
        imgPickerAlert.addAction(cancelAction)
        
        self.present(imgPickerAlert, animated: true, completion: nil)
        
    }
    // 開啟相機
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imgPicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imgPicker.allowsEditing = true
            
            self.present(imgPicker, animated: true, completion: nil)
            
            getStatus()
            
        }else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    // 開啟相簿
    func openGallary() {
        // 打開的相簿樣式
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imgPicker.allowsEditing = true
        
        self.present(imgPicker, animated: true, completion: nil)
        
        getStatus()
        
    }
    
    // ImagePickerControllerDelegate 實作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 圖片放到 ImageView 上
        upDatePic.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        // 取得圖片路徑
        let fileManager = FileManager.default

        let fileURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let file = fileURLs
        // 圖片檔名格式
        let interval = Date.timeIntervalSinceReferenceDate
        // 圖片檔名
        let fileName = "\(interval).jpg"
        
        let ImgURL = file.appendingPathComponent(fileName)
        // 把圖片存在 APP 裡，壓縮係數
        let ImgData = UIImageJPEGRepresentation(upDatePic.image!, 0.9)
        
        do {
            try ImgData?.write(to: ImgURL)

        }catch {
            print("Can't write ImgURL")

        }
        
        let ImgURLstr = String(describing: ImgURL)
        
        AddFinPostViewModel.cusImg = ImgURLstr
        
        print(AddFinPostViewModel.cusImg)
        
        dismiss(animated: true, completion: nil)

        print("Gallery is OK")
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        print("ImgPicker Cancel")
        
    }
    
    func getStatus() {
        let openstatus = PHPhotoLibrary.authorizationStatus()
        
        switch openstatus {
        // 使用者接受存取照片權限
        case .authorized:
            print("PhotoLibrary is authorized")
        // 使用者拒絕存取照片權限
        case .denied:
            print("PhotoLibrary is denied")
        // 沒有存取照片權限
        case .restricted:
            print("PhotoLibrary is restricted")
        // 使用者沒有對權限作出選擇時
        case .notDetermined:
            // 請求權限
            PHPhotoLibrary.requestAuthorization({ (openstatus) in
                switch openstatus {
                case .authorized:
                    print("PhotoLibrary is authorized")
                    
                case .denied:
                    print("PhotoLibrary is denied")
                    
                case .restricted:
                    print("PhotoLibrary is restricted")
                    
                case .notDetermined:
                    //...
                    break
                }
                
            })
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
