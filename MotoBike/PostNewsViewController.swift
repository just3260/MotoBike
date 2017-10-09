//
//  PostNewsViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/10/8.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

class PostNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var PostNewsTableView: UITableView!
    
    var PostData = [String!]()
    
    var NewsSelectedIndex: IndexPath?
    
    var PostisExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let PostNewsnib = UINib.init(nibName: "PostNewsTableViewCell", bundle: nil)
        
        self.PostNewsTableView.register(PostNewsnib, forCellReuseIdentifier: "cell")
        
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostNewsTableViewCell
        
        // let PostDataItem = self.PostData[indexPath.row]
        
        cell.weatherCellLabel.text = PostData[0]
        
        cell.trafficCellLabel.text = PostData[1]
        
        cell.decideTagCellLabel.text = PostData[2]
        
        cell.locationCellLabel.text = PostData[3]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.NewsSelectedIndex = indexPath
        
        self.didPostExpanCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(PostisExpanded && self.NewsSelectedIndex == indexPath) {
            return 400
            
        }
        
        return 215
        
    }
    
    func didPostExpanCell() {
        self.PostisExpanded = !PostisExpanded
        
        self.PostNewsTableView.reloadRows(at: [NewsSelectedIndex!], with: .automatic)
        
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
