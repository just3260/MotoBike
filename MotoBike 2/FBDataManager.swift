//
//  FBDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/9.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import FBSDKLoginKit
// 定義常數
let URL_INSERT_FBLOGIN = "http://localhost/FBLogin.php?func=insert"

@objc protocol FBKeyinDelegate: NSObjectProtocol {
     @objc optional func FBLoginData(LoginKey: [String])
    
}

class FBDataManager: NSObject {
    var FBLogin: FBKeyinDelegate!

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
                
                // 將字串轉成 URL 型別，判斷是否為 nil
                guard let FBRequestURL = URL(string: URL_INSERT_FBLOGIN) else {
                    return
                    
                }
                // 資料庫本身有定義 id 欄位，將取得的 id 放到另一個變數，避免存取欄位相同
                let FBID = id
                // 宣告變數，請求 POST 回傳
                let FBRequest = NSMutableURLRequest(url: FBRequestURL)
                // 設置接收方的請求方式
                FBRequest.httpMethod = "POST"
                // 將傳輸參數帶入
                let postFBParameters = "FBID=\(FBID)&name=\(name)&email=\(email)&url=\(url)"
                // 設置接收方的 HTTP 請求方式
                FBRequest.httpBody = postFBParameters.data(using: String.Encoding.utf8)
                // URLSession 的 URLRequest 會夾帶參數進去，傳出去的方式為 task
                // shared: 使用單例模式，在登入新帳號時，只需要初始化一次就好，可以讓 APP 拿到同一個 instance，讓其他的程式可以共用
                // dataTask: 是一個逃逸閉包，當所有 func 執行完，才會執行到閉包裡的程式碼
                let FBtask = URLSession.shared.dataTask(with: FBRequest as URLRequest) { (data, response, error) in
                    // task 回傳錯誤的訊息參數
                    guard error == nil else {
                        print("error is \(error!.localizedDescription)")
                        
                        return
                        
                    }
                    // task 回傳資料的訊息參數
                    guard let data = data else {
                        print("No data was returned by the request!")
                        
                        return
                        
                    }
                    // 回傳的訊息結果
                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    print("responseString:\(String(describing: responseString))")
                    
                }
                // resume(): 異步執行，配合上面的 dataTask 逃逸閉包，把 dataTask 變成當需要調用的時候，才恢復執行
                FBtask.resume()
                
            })
        }else {
            print("未登入帳號")
            
        }
        
    }
    
}
