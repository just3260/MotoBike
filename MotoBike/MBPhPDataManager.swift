//
//  MBPhPDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/29.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation
// 定義常數
let URL_INSERT_FBLOGIN = "http://localhost/FBLogin.php?func=insert"

let URL_DELETE_FBLOGIN = "http://localhost/FBLogin.php?func=del"
// 將輸入陣列轉換成其他字串
// 資料庫本身有定義 id 欄位，將取得的 id 放到另一個變數，避免存取欄位相同
var PHP_Array = [String]()

var PHP_FBID = PHP_Array[0]

var PHP_name = PHP_Array[3]

var PHP_email = PHP_Array[1]

var PHP_url = PHP_Array[5]

var PHP_ID = ""

class MBPhPDataManager: NSObject {
    var allPHPArray = [String]()
    
    func getFBLogionInsert(allPHPURL: String)  {
        // 將字串轉成 URL 型別，判斷是否為 nil
        guard let FBRequestURL = URL(string: allPHPURL) else {
            return
            
        }
        // 宣告變數，請求 POST 回傳
        let FBRequest = NSMutableURLRequest(url: FBRequestURL)
        // 將傳輸參數帶入
        switch allPHPURL {
        case URL_INSERT_FBLOGIN:
            let InsertParameters = "FBID=\(PHP_FBID)&name=\(PHP_name)&email=\(PHP_email)&url=\(PHP_url)"
            // 設置接收方的 HTTP 請求方式
            FBRequest.httpBody = InsertParameters.data(using: String.Encoding.utf8)
            
        case URL_DELETE_FBLOGIN:
            let DeleteParameters = "id=\(PHP_ID)"
            // 設置接收方的 HTTP 請求方式
            FBRequest.httpBody = DeleteParameters.data(using: String.Encoding.utf8)
            
        default:
            break
            
        }
        // 設置接收方的請求方式
        FBRequest.httpMethod = "POST"
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
        
    }
    
    
}
