//
//  NavigationMenuViewController.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/28.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import InteractiveSideMenu

/*
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
class NavigationMenuViewController: MenuViewController {
    
    // user的登入資料
    var loginData = [String]()
    // cell要顯示的資料
    var cellData = [(UIImage, String, Bool)]()
    
    @IBOutlet weak var menuTableView: UITableView!
    // 放置大頭照的View
    @IBOutlet weak var userImage: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // xib的名稱
        let nib = UINib(nibName: "MenuTableCell", bundle: nil)
        //註冊，forCellReuseIdentifier是你的TableView裡面設定的Cell名稱
        menuTableView.register(nib, forCellReuseIdentifier: "MenuCell")
        
        // Select the initial row
        menuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        menuTableView.separatorStyle = .none
        
        cellData.append((UIImage(named: "map")!, "Map", true))
        cellData.append((UIImage(named: "gas")!, "Gas Station", false))
        cellData.append((UIImage(named: "parking")!, "Parking", false))
        cellData.append((UIImage(named: "post")!, "Post", true))
        cellData.append((UIImage(named: "message")!, "Message", true))
        cellData.append((UIImage(named: "facebook")!, "Facebook", true))
        
        userImage.layer.contents = UIImage(named: "people")?.cgImage
        userImage.layer.contentsGravity = kCAGravityResize
        userImage.layer.masksToBounds = true
//        let background = UIImage(named: "people")
//        userImage.backgroundColor = UIColor(patternImage: background!)
        
        if UserDefaults.standard.array(forKey: "FBData") != nil {
            loginData = UserDefaults.standard.array(forKey: "FBData") as! [String]
            FBUserData()
        }
        // 設置Row的高度
//        let cellHeight = Int(menuTableView.frame.size.height) / cellData.count
//        menuTableView.rowHeight = CGFloat(cellHeight)
    }
    

    
    /// 登入頁面輸入完畢，顯示個人資訊
    func FBUserData() {
        
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
        
        userImage.layer.shadowOffset = CGSize(width: 5, height: 5)
        userImage.layer.shadowOpacity = 0.7
        userImage.layer.shadowRadius = 5
        userImage.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
//        idTextLable.text = loginData[0]
//        nameTextLabel.text = loginData[3]
//        emailTextLabel.text = loginData[1]
        
        let userID = loginData[0]
        let imageURL = "http://graph.facebook.com/\(userID)/picture?type=large"
        let profileImgURL = NSURL(string: imageURL)
        
        guard let profileImgData = NSData(contentsOf: profileImgURL! as URL) else {
            return
        }
        
        userImage.layer.contents = UIImage(data: profileImgData as Data)?.cgImage
        userImage.layer.contentsGravity = kCAGravityResize
        userImage.layer.masksToBounds = true
        
    }
}

/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //取得myTableView的cell，名稱是myTableView輸入的Cell Identifier
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableCell
        
        cell.menuImage.image = cellData[indexPath.row].0
        cell.menuLabel.text = cellData[indexPath.row].1
        cell.menuSwitchOutlet.isHidden = cellData[indexPath.row].2
        
        return cell
    }
    
    
    // 選取cell時執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = menuTableView.cellForRow(at: indexPath) as! MenuTableCell
        cell.menuLabel.textColor = #colorLiteral(red: 0.9669716954, green: 0.8325224519, blue: 0.4720008373, alpha: 1)
        cell.selectView.backgroundColor = #colorLiteral(red: 0.9669716954, green: 0.8325224519, blue: 0.4720008373, alpha: 1)
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
        
    }
    
    
    // 取消選取cell時的動作
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = menuTableView.cellForRow(at: indexPath) as! MenuTableCell
        cell.menuLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.selectView.backgroundColor = #colorLiteral(red: 0.2710422277, green: 0.6251875758, blue: 0.6341569424, alpha: 1)
    }
    
    
    // 長按cell時的動作(highlight)
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = menuTableView.cellForRow(at: indexPath) as! MenuTableCell
//        cell.menuLabel.textColor = #colorLiteral(red: 0.9669716954, green: 0.8325224519, blue: 0.4720008373, alpha: 1)
//        cell.selectView.backgroundColor = #colorLiteral(red: 0.9669716954, green: 0.8325224519, blue: 0.4720008373, alpha: 1)
    }
    
    
    // 取消長按cell時的動作(highlight)
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = menuTableView.cellForRow(at: indexPath) as! MenuTableCell
//        cell.menuLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        cell.selectView.backgroundColor = #colorLiteral(red: 0.2710422277, green: 0.6251875758, blue: 0.6341569424, alpha: 1)
    }
    
    
    
}



