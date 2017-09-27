//
//  FBDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/9.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@objc protocol FBKeyinDelegate: NSObjectProtocol {
     @objc optional func FBLoginData(LoginKey: [String])
    
}

struct LoginPhpDataManager {
    static let URL_ADD_FBLOGIN = "http://localhost/FBLogin.php?func=insert"
    
}

class FBDataManager: NSObject {
    var FBLogin: FBKeyinDelegate!
    
    var aaa: selectPinData!

    func getUserData() {
        if(FBSDKAccessToken.current() != nil) {
            print("已經登入帳號")
            // 登入帳號信息格式
            let FBinfo = ["fields": "email, first_name, id, last_name, name, picture"]
            // 向 FB 請求 Grap API 圖片的信息，一起傳遞附加參數
            // parameters: 透過請求，附加傳遞的參數
            let FBgrapRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: FBinfo)!
            
            FBgrapRequest.start(completionHandler: { (connection, result, error) in
                
                guard let resultData = result as? NSDictionary,
                    
                      let id = resultData["id"] as? String,
                    
                      let email = resultData["email"] as? String,
                    
                      let firstName = resultData["first_name"] as? String,
                    
                      let name = resultData["name"] as? String,
                    
                      let lastName = resultData["last_name"] as? String,
                    
                      let picture = resultData["picture"] as? NSDictionary,
                
                      let data = picture["data"] as? NSDictionary,
                
                      let url = data["url"] as? String
                    
                else {
                    print("FBinfo 格式錯誤")
                    
                    return
                    
                }
                
                print(result!)

                print(id)
                
                print(email)
                
                print(firstName)
                
                print(name)
                
                print(lastName)
                
                print(url)
                
                let infoarray = [id, email, firstName, name, lastName, url]
                
                self.FBLogin.FBLoginData?(LoginKey: infoarray)

            })
        }else {
            print("未登入帳號")
            
        }
        
    }
    
}
