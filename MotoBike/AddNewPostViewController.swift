//
//  AddNewPostViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/14.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

class AddNewPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FinPostViewDelegate {
    
    @IBOutlet weak var pickerItemLabel: UILabel!
    
    @IBOutlet weak var areaLocation: UITextField!
    
    @IBOutlet weak var updatePic: UIImageView!
    
    let AddFinPostViewModel = PostViewDataManager()
    
    let PinModel = selectPinData()
    
    let areaTagArray = ["無路況", "北北基路況", "桃竹苗路況", "中彰投路況", "雲嘉南路況", "高高屏路況", "車聚與揪跑", "協助與求救"]
    
    var locationInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AddFinPostViewModel.getPostItem = self
        
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
        getselectPinDataAddress()
        
        let imgTapGesture = UITapGestureRecognizer(target: self, action: #selector(getImageTap(gesture:)))
        
        updatePic.isUserInteractionEnabled = true
        
        updatePic.addGestureRecognizer(imgTapGesture)
        
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
        
        locationInput = areaLocation.text!
        
        AddFinPostViewModel.location = locationInput
        
        print(AddFinPostViewModel.location)
        
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
            
        }
        
    }
    
    func getImageTap(gesture: UITapGestureRecognizer) {
        print("image Tap")
        
        openActionSheet()
        
    }
    
    func openActionSheet() {
        let picActionVC = UIAlertController(title: "功能選擇", message: "", preferredStyle: .actionSheet)
        
        let picCamera = UIAlertAction(title: "Camera", style: .default, handler: nil)
        
        let picGallery = UIAlertAction(title: "Gallery", style: .default, handler: nil)
        
        let picCancel = UIAlertAction(title: "Cacel", style: .default, handler: nil)
        
        picActionVC.addAction(picCamera)
        
        picActionVC.addAction(picGallery)
        
        picActionVC.addAction(picCancel)
        
        present(picActionVC, animated: true, completion: nil)
        
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
