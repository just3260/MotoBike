//
//  MBPhPDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/29.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation

class MBPhPDataManager: NSObject {
    
    var allPHPArray = [String]()
    
    func getPHPData(allPHPURL: String)  {
        // 將字串轉成 URL 型別，判斷是否為 nil
        guard let PHPRequestURL = URL(string: allPHPURL) else {
            return
            
        }
        // 宣告變數，請求 POST 回傳
        let PHPRequest = NSMutableURLRequest(url: PHPRequestURL)
        // 將傳輸參數帶入
        switch allPHPURL {
        // FB 登入帳號新增
        case URL_INSERT_FBLOGIN:
            let InsertParameters = "FBID=\(FBLOGIN_FBID)&name=\(FBLOGIN_NAME)&email=\(FBLOGIN_EMAIL)&url=\(FBLOGIN_URL)"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = InsertParameters.data(using: String.Encoding.utf8)
        // FB 登出帳號刪除
        case URL_DELETE_FBLOGIN:
            let DeleteParameters = "id=\(1)"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = DeleteParameters.data(using: String.Encoding.utf8)
        
        case URL_SELECT_ALL_INFO:
            break
        // 重機停車塲資料庫下載一筆
        case URL_SELECT_ONE_INFO:
            let SelectOneParameters = "id"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = SelectOneParameters.data(using: String.Encoding.utf8)
            
        default:
            break
            
        }
        // 設置接收方的請求方式
        PHPRequest.httpMethod = "POST"
        
        let PHPsession = URLSession.shared
        // URLSession 的 URLRequest 會夾帶參數進去，傳出去的方式為 task
        // shared: 使用單例模式，在登入新帳號時，只需要初始化一次就好，可以讓 APP 拿到同一個 instance，讓其他的程式可以共用
        // dataTask: 是一個逃逸閉包，當所有 func 執行完，才會執行到閉包裡的程式碼
        let PHPtask = PHPsession.dataTask(with: PHPRequest as URLRequest) { (data, response, error) in
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
            // InfoJSON 解析下來的資料
//            let infodecoder = JSONDecoder()
//
//            guard let infoDataList = try? infodecoder.decode(InfoData.self, from: data) else {
//                print("No infoData was returned by the request!")
//
//                return
//
//            }
//
//            print("id:\(infoDataList.id)")
//
//            print("name:\(infoDataList.name)")
//
//            print("address:\(infoDataList.address)")
//
//            print("area_id:\(infoDataList.area_id)")
//
//            print("InfoSelectOneJSON is OK")
            // 回傳的訊息結果
            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            print("responseString:\(String(describing: responseString))")
            
        }
        // resume(): 異步執行，配合上面的 dataTask 逃逸閉包，把 dataTask 變成當需要調用的時候，才恢復執行
        PHPtask.resume()
        
    }
    
}
