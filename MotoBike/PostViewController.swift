//
//  PostViewController.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/12.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class PostNavigationViewController: UINavigationController, SideMenuItemContent {
}

//UINavigationItem



class PostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // 取消貼文，回到地圖畫面
    @IBAction func cancelPostView(_ sender: Any) {
        // 頁面返回的動畫效果
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
