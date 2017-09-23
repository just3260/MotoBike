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
    
    let FinPostViewModel = PostViewDataManager()
    
    let areaTagArray = ["無路況", "北北基路況", "桃竹苗路況", "中彰投路況", "雲嘉南路況", "高高屏路況", "車聚與揪跑", "協助與求救"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FinPostViewModel.getPostItem = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Sunny(_ sender: UIButton) {
        let sun = "晴天地乾"
        
        FinPostViewModel.weather.removeAll()
        
        FinPostViewModel.weather.append(sun)
        
        print(FinPostViewModel.weather)
        
    }
    
    @IBAction func overcastCloudy(_ sender: UIButton) {
        let cloudy = "陰天有雲"
        
        FinPostViewModel.weather.removeAll()
        
        FinPostViewModel.weather.append(cloudy)
        
        print(FinPostViewModel.weather)
        
    }
    
    @IBAction func rainny(_ sender: UIButton) {
        let rain = "雨天地濕"
        
        FinPostViewModel.weather.removeAll()
        
        FinPostViewModel.weather.append(rain)
        
        print(FinPostViewModel.weather)
        
    }
    
    @IBAction func normalDriving(_ sender: UIButton) {
        let normal = "正常行駛"
        
        FinPostViewModel.traffic.removeAll()
        
        FinPostViewModel.traffic.append(normal)
        
        print(FinPostViewModel.traffic)
        
    }
    
    @IBAction func takeDanger(_ sender: UIButton) {
        let danger = "注意危險"
        
        FinPostViewModel.traffic.removeAll()
        
        FinPostViewModel.traffic.append(danger)
        
        print(FinPostViewModel.traffic)
        
    }
    
    @IBAction func noPassing(_ sender: UIButton) {
        let stop = "禁止通行"
        
        FinPostViewModel.traffic.removeAll()
        
        FinPostViewModel.traffic.append(stop)
        
        print(FinPostViewModel.traffic)
        
    }
    
    @IBAction func areaTag(_ sender: UIButton) {
         getPickerView()
        
    }
    
    @IBAction func confirmLocation(_ sender: UIButton) {
        
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        
    }
    
    @IBAction func FinPostViewBarBtn(_ sender: UIBarButtonItem) {
        if(FinPostViewModel.decideTag.isEmpty) {
            FinPostViewModel.decideTag = areaTagArray[0]
            
        }
        
        FinPostViewModel.getPostViewData()
        
    }
    
    @IBAction func CancelPostViewBtn(_ sender: UIBarButtonItem) {
        FinPostViewModel.postItem.removeAll()
        
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
        FinPostViewModel.decideTag = areaTagArray[row]
        
        pickerItemLabel.text = FinPostViewModel.decideTag
        
        print(FinPostViewModel.decideTag)
        
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
