//
//  InfoDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/10/6.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation

struct InfoData: Codable {
    var id: String
    
    var name: String
    
    var address: String
    
    var area_id: String
    
}

let infoData: InfoData = InfoData(id: "", name: "", address: "", area_id: "")

let infoEncoder: JSONEncoder = JSONEncoder()

let infoEncoded = try? infoEncoder.encode(infoData)

let infoDecoder: JSONDecoder = JSONDecoder()

let infoDecoded = try? infoDecoder.decode(InfoData.self, from: infoEncoded!)
