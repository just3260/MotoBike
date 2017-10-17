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
let URL_INSERT_FBLOGIN = "https://rt72615.000webhostapp.com/FBLogin.php?func=insert"

let URL_DELETE_FBLOGIN = "https://rt72615.000webhostapp.com/FBLogin.php?func=del"

var FBLOGIN_ARRAY = [String]()

var FBLOGIN_FBID = FBLOGIN_ARRAY[0]

var FBLOGIN_NAME = FBLOGIN_ARRAY[3]

var FBLOGIN_EMAIL = FBLOGIN_ARRAY[1]

var FBLOGIN_URL = FBLOGIN_ARRAY[5]
// 重機停車場資料庫
let URL_SELECT_ALL_INFO = "https://rt72615.000webhostapp.com/info.php?func=selectAll"

let URL_SELECT_ONE_INFO = "https://rt72615.000webhostapp.com/info.php?func=selectOne"

var INFO_ID = ""

var INFO_NAME = ""

var INFO_ADDRESS = ""

var INFO_AREA_ID = ""
// PostNews 資料庫
let URL_INSERT_POSTNEWS = "https://rt72615.000webhostapp.com/PostNews.php?func=insert"

let URL_SELECT_ALL_POSTNEWS = "https://rt72615.000webhostapp.com/PostNews.php?func=selectAll"

var POSTNEWS_ARRAY = [String]()

var POSTNEWS_WEATHER = POSTNEWS_ARRAY[0]

var POSTNEWS_TRAFFIC = POSTNEWS_ARRAY[1]

var POSTNEWS_DECIDETAG = POSTNEWS_ARRAY[2]

var POSTNEWS_LOCATION = POSTNEWS_ARRAY[3]

var POSTNEWS_IMAGE = POSTNEWS_ARRAY[4]




