//
//  FBLoginViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/8.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController, FBKeyinDelegate{
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var idTextLable: UILabel!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    
    @IBOutlet weak var emailTextLabel: UILabel!
    
    var loginData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginData = UserDefaults.standard.array(forKey: "FBData") as! [String]
        
        FBLoginStart()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // 登入頁面輸入完畢，顯示個人資訊
    func FBLoginStart() {
        
        idTextLable.text = loginData[0]
        
        nameTextLabel.text = loginData[3]
        
        emailTextLabel.text = loginData[1]
        
        let profileImgURL = NSURL(string: loginData[5])
        
        let profileImgData = NSData(contentsOf: profileImgURL! as URL)
        
        profileImg.image = UIImage(data: profileImgData! as Data)
        
    }
    
    // 登出FB
    @IBAction func FBLoginOutBtn(_ sender: Any) {
        let manger = FBSDKLoginManager()
        manger.logOut()
        
        UserDefaults.standard.removeObject(forKey: "FBData")
        self.modalTransitionStyle = .crossDissolve
        dismiss(animated: true, completion: nil)
    }
    
    // 回到地圖畫面
    @IBAction func backToMap(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        dismiss(animated: true, completion: nil)
    }
    
    func FBLoginData(LoginKey: [String]) {
        //...
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
