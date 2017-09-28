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
    
    let kCellReuseIdentifier = "MenuCell"
    let menuItems = ["Map", "Post", "Add New Item", "FB"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
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
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
    }
}



