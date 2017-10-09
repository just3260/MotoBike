//
//  DefineDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/10/5.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation

// 定義常數
// 將輸入陣列轉換成其他字串
// 資料庫本身有定義 id 欄位，將取得的 id 放到另一個變數，避免存取欄位相同

// FB 登入帳號資料庫
let URL_INSERT_FBLOGIN = "http://localhost/FBLogin.php?func=insert"

let URL_DELETE_FBLOGIN = "http://localhost/FBLogin.php?func=del"

var FBLOGIN_ARRAY = [String]()

var FBLOGIN_FBID = FBLOGIN_ARRAY[0]

var FBLOGIN_NAME = FBLOGIN_ARRAY[3]

var FBLOGIN_EMAIL = FBLOGIN_ARRAY[1]

var FBLOGIN_URL = FBLOGIN_ARRAY[5]
// 重機停車場資料庫
let URL_SELECT_ALL_INFO = "http://localhost/info.php?func=selectAll"

let URL_SELECT_ONE_INFO = "http://localhost/info.php?func=selectOne"

var Parmeters_ID = 1

var INFO_ID = ""

var INFO_NAME = ""

var INFO_ADDRESS = ""

var INFO_AREA_ID = ""
