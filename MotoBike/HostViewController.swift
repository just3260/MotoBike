//
//  HostViewController.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/9/28.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import Foundation
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.5, visibleContentWidth: screenSize.width / 4)
        
        // Instantiate menu view controller by identifier
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
        
        // Gather content items controllers
        self.contentViewControllers = contentControllers()
        
        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)
    }
    
    
    
    
    private func contentControllers() -> [UIViewController] {
        
        var contentList = [UIViewController]()
        
        contentList.append(UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController"))
        contentList.append(UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController"))
        contentList.append(UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController"))
        contentList.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewPostViewController"))
        contentList.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController"))
        contentList.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FBLoginViewController"))

        return contentList
    }
    

}
