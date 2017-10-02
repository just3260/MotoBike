//
//  AddNewPostViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/14.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import Photos

class AddNewPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FinPostViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickerItemLabel: UILabel!
    
    @IBOutlet weak var areaLocation: UITextField!
    
    @IBOutlet weak var updatePic: UIImageView!
    
    let AddFinPostViewModel = PostViewDataManager()
    
    let PinModel = selectPinData()
    
    let areaTagArray = ["無路況", "北北基路況", "桃竹苗路況", "中彰投路況", "雲嘉南路況", "高高屏路況", "車聚與揪跑", "協助與求救"]
    
    var locationInput = ""
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imgTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageTap(gesture:)))
        
        updatePic.isUserInteractionEnabled = true
        
        updatePic.addGestureRecognizer(imgTapGesture)
        
        AddFinPostViewModel.getPostItem = self
        
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
        getselectPinDataAddress()
        
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
            
        }
        
        AddFinPostViewModel.getPostViewData()
        
    }
    
    @IBAction func CancelPostViewBtn(_ sender: UIBarButtonItem) {
        AddFinPostViewModel.postItem.removeAll()
        
        self.modalTransitionStyle = .crossDissolve
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func getPickerView() {
        let areaTagVC = UIViewController()
        
        areaTagVC.preferredContentSize = CGSize(width: 250, height: 300)
        
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
    func getImageTap(gesture: UITapGestureRecognizer) {
        print("image Tap")
        
        openActionSheet()
        
    }
    
    func openActionSheet() {
        let picActionVC = UIAlertController(title: "功能選擇", message: "", preferredStyle: .actionSheet)
        
        let picCamera = UIAlertAction(title: "Camera", style: .default, handler: cameraAction)
        
        let picGallery = UIAlertAction(title: "Gallery", style: .default, handler: galleryAction)
        
        let picCancel = UIAlertAction(title: "Cacel", style: .default, handler: nil)
        
        imgPicker.delegate = self
        
        picActionVC.addAction(picCamera)
        
        picActionVC.addAction(picGallery)
        
        picActionVC.addAction(picCancel)
        
        self.present(picActionVC, animated: true, completion: nil)
        
    }
    // 開啟相機
    func cameraAction(camera: UIAlertAction) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imgPicker.sourceType = .camera
            
            imgPicker.allowsEditing = true
            
            self.present(imgPicker, animated: true, completion: nil)
            
        }else {
            print("Camera is not Aviable")
            
        }
        
    }
    // 開啟相簿
    func galleryAction(gallery: UIAlertAction) {
        // 打開的相簿樣式
        imgPicker.sourceType = .photoLibrary
        
        self.present(imgPicker, animated: true, completion: nil)
        
    }
    
    // ImagePickerControllerDelegate 實作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 圖片放到 ImageView 上
        if let FinimgPicker = info[UIImagePickerControllerEditedImage] as? UIImage {
            updatePic.image = FinimgPicker

            return

        }
        
        dismiss(animated: true, completion: nil)
        
        print("gallery is OKOKOK")
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        print("Img Cancel")
        
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
