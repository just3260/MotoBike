//
//  PostViewDataManager.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/9/23.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

@objc protocol FinPostViewDelegate {
    @objc optional func FinPostArray(contents: [String])
    
}

struct allNavigationBarAttributes {
    static let allNavigationbarBg = UIImage(named: "NavigatoinBarBg")

}

class PostViewDataManager: NSObject {
    var getPostItem: FinPostViewDelegate!
    
    var weather = [String!]()
    
    var traffic = [String!]()
    
    var weatherContents: String?
    
    var trafficContents: String?
    
    var decideTag = ""
    
    var location = ""
    
    var postItem = [String!]()
    
    func getPostViewData() {
        guard let weather = weather.first else {
            print("weatherContents is nil")
            
            return
            
        }
        
        weatherContents = weather
        
        guard let traffic = traffic.first else {
            print("trafficContents is nil")
            
            return
            
        }
        
        trafficContents = traffic
        
        if(postItem.isEmpty) {
            postItem = [weatherContents, trafficContents, decideTag, location]
            
            print("posItem is nil")
            
        }
        
        postItem = [weatherContents, trafficContents, decideTag, location]
        
        print(postItem)
        
    }

    
    let imgTapGesture = UITapGestureRecognizer(target: PostViewController.self, action: #selector(getImageTap(gesture:)))
    
    func getImageTap(gesture: UITapGestureRecognizer) {
        print("image Tap")
        
        openActionSheet()
        
    }
    
    func openActionSheet() {
        let picActionVC = UIAlertController(title: "功能選擇", message: "", preferredStyle: .actionSheet)
        
        let picCamera = UIAlertAction(title: "Camera", style: .default, handler: nil)
        
        let picGallery = UIAlertAction(title: "Gallery", style: .default, handler: nil)
        
        let picCancel = UIAlertAction(title: "Cacel", style: .default, handler: nil)
        
        picActionVC.addAction(picCamera)
        
        picActionVC.addAction(picGallery)
        
        picActionVC.addAction(picCancel)
        
//        AddNewPostViewController.present()
        
    }


}
