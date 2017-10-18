//
//  MBPhPDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/29.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation

class MBPhPDataManager: NSObject {
    // 裝停車場資料
    var allPHPArray = [[String : String]]()
    
    func getPHPData(allPHPURL: String) {
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
            let FBLoginInsertParameters = "FBID=\(FBLOGIN_FBID)&name=\(FBLOGIN_NAME)&email=\(FBLOGIN_EMAIL)&url=\(FBLOGIN_URL)"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = FBLoginInsertParameters.data(using: String.Encoding.utf8)
        // FB 登出帳號刪除
        case URL_DELETE_FBLOGIN:
            let FBLoginDeleteParameters = "id=\(1)"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = FBLoginDeleteParameters.data(using: String.Encoding.utf8)
        // 重機停車場資料下載全部
        case URL_SELECT_ALL_INFO:
            break
        // 重機停車塲資料庫下載一筆
        case URL_SELECT_ONE_INFO:
            let SelectOneParmeters = "id=\(1)"
            // 設置接收方的 HTTP 請求方式
            PHPRequest.httpBody = SelectOneParmeters.data(using: String.Encoding.utf8)
        // 抓取發文頁面資料
        case URL_INSERT_POSTNEWS:
            let PostNewsParmeters = "weather=\(POSTNEWS_WEATHER)&traffic=\(POSTNEWS_TRAFFIC)&decideTag=\(POSTNEWS_DECIDETAG)&location=\(POSTNEWS_LOCATION)&image=\(POSTNEWS_IMAGE)"
            
            PHPRequest.httpBody = PostNewsParmeters.data(using: String.Encoding.utf8)
            
        case URL_SELECT_ALL_POSTNEWS:
            break
            
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
            // 整筆資料庫解析
//            if(allPHPURL == URL_SELECT_ALL_INFO) {
//                do {
//                    guard let infoAllDataList = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray else {
//                        print("No infoAllDataList was returned by the request!")
//
//                        return
//
//                    }
//                    // 將停車場每筆資料取出
//                    for infoAllItem in 0...74 {
//                        guard let infoAllDataResult = infoAllDataList[infoAllItem] as? NSDictionary else {
//                            print("infoAllDataResult isn't NSDictionary")
//
//                            return
//
//                        }
//
//                        guard let infoAllResultID = infoAllDataResult["id"] as? String,
//
//                              let infoAllReusultNAME = infoAllDataResult["name"] as? String,
//
//                              let infoAllResultADDRESS = infoAllDataResult["address"] as? String,
//
//                              let infoAllResultAREA_ID = infoAllDataResult["area_id"] as? String,
//
//                              let infoAllResultLONGITUDE = infoAllDataResult["longitude"] as? String,
//
//                              let infoAllResultLATITUDE = infoAllDataResult["latitude"] as? String
//
//                        else {
//                                print("Can't take infoAllDataRsult.keys to infoAllResult")
//
//                                return
//
//                        }
//
//                        let infoAllResult = ["id": infoAllResultID,
//
//                                             "name": infoAllReusultNAME,
//
//                                             "address": infoAllResultADDRESS,
//
//                                             "area_id": infoAllResultAREA_ID,
//
//                                             "longitude": infoAllResultLONGITUDE,
//
//                                             "latitude": infoAllResultLATITUDE]
//
//                        // print(infoAllResult)
//
//                        self.allPHPArray.append(infoAllResult)
//
//                    }
//
//                    // print(self.allPHPArray)
//
//                    selectPinData.allParkingArray = self.allPHPArray
//
//                } catch {
//                    print("error is \(error.localizedDescription)")
//
//                }
//
//            }
            // 單筆資料庫解析
//            if(allPHPURL == URL_SELECT_ONE_INFO) {
//                let infoDecoder = JSONDecoder()
//
//                guard let infoDataList = try? infoDecoder.decode(InfoData.self, from: data) else {
//                    print("No infoData was returned by the request!")
//
//                    return
//                    
//                }
//                
//                print(infoDataList)
//                
//                let infoResultID = ["id": infoDataList.id]
//
//                print("id:\(infoResultID)")
//                
//                let infoResultNAME = ["name": infoDataList.name]
//
//                print("name:\(infoResultNAME)")
//
//                let infoResultADDRESS = ["address": infoDataList.address]
//
//                print("address:\(infoResultADDRESS)")
//
//                let infoResultAREA_ID = ["area_id": infoDataList.area_id]
//                
//                print("area_id:\(infoResultAREA_ID)")
//                
//            }
            
            if(allPHPURL == URL_SELECT_ALL_POSTNEWS) {
                do {
                    guard let PostNewsAllDataList = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray else {
                        print("No PostNewsAllDataList was returned by the request!")
                        
                        return
                        
                    }
                    
                    for PostNewsAllItem in 0...PostNewsAllDataList.count {
                        guard let PostNewsAllDataResult = PostNewsAllDataList[PostNewsAllItem] as? NSDictionary else {
                            print("PostNewsAllDataResult isn't NSDictionary")
                            
                            return
                            
                        }
                        
                        guard let PostNewsAllDataResultWEATHER = PostNewsAllDataResult["weather"] as? String,

                            let PostNewsAllDataResultTRAFFIC = PostNewsAllDataResult["traffic"] as? String,

                            let PostNewsAllDataResultDECIDETAG = PostNewsAllDataResult["decideTag"] as? String,

                            let PostNewsAllDataResultLOCATION = PostNewsAllDataResult["location"] as? String,

                            let PostNewsAllDataResultIMAGE = PostNewsAllDataResult["image"] as? String

                            else {
                                print("Can't take PostNewsAllDataResult.keys to PostNewsAllDataResult")

                                return
                                
                        }
                        

                        print(PostNewsAllDataResult)

//                        let infoAllResult = ["id": infoAllResultID,
//                                             
//                                             "name": infoAllReusultNAME,
//                                             
//                                             "address": infoAllResultADDRESS,
//                                             
//                                             "area_id": infoAllResultAREA_ID,
//                                             
//                                             "longitude": infoAllResultLONGITUDE,
//                                             
//                                             "latitude": infoAllResultLATITUDE]
                        
//                        print(infoAllResult)

                        
                    }
                    
                } catch {
                    print("error is \(error.localizedDescription)")
                    
                }
                
                
            }
            
            let InfoOK = "InfoJSON is OK"
//            // 回傳的訊息結果
            if(InfoOK.isEmpty) {
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                print("responseString:\(String(describing: responseString))")
                
            }
            
        }

        // resume(): 異步執行，配合上面的 dataTask 逃逸閉包，把 dataTask 變成當需要調用的時候，才恢復執行
        PHPtask.resume()
    }
    
    
    
    
    
}
