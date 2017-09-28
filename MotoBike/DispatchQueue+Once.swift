//
//  DispatchQueue+Once.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/13.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    
    private static var _onceTokens = [String]()
    
    // Class method vs Instance method
    public class func once(token: String, job: () -> Void) {
        
        // 類似一把鎖，用來控管多核心平行處理時，物件的執行
        objc_sync_enter(self)
        
        // defer：延遲執行，等離開整個func（或"{}"內的程式碼）時再執行defer內的程式
        defer {
            objc_sync_exit(self)
        }
        
        if _onceTokens.contains(token) {
            return
        }
        _onceTokens.append(token)
        job()
    }
    
}
