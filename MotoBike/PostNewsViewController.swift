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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostNewsTableViewCell
        
    
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 210))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
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
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let shadowView = UIView()
//
//
//
//
//        let gradient = CAGradientLayer()
//        gradient.frame.size = CGSize(width: PostNewsTableView.bounds.width, height: 15)
//        let stopColor = UIColor.gray.cgColor
//
//        let startColor = UIColor.white.cgColor
//
//
//        gradient.colors = [stopColor,startColor]
//
//
//        gradient.locations = [0.0,0.8]
//
//        shadowView.layer.addSublayer(gradient)
//
//
//        return shadowView
//
//    }
    
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
