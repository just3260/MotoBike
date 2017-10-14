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
        // PostNewsTableView 陰影效果
        PostNewsContainerView()
        // Do any additional setup after loading the view.
        let PostNewsNib = UINib.init(nibName: "PostNewsTableViewCell", bundle: nil)
        
        self.PostNewsTableView.register(PostNewsNib, forCellReuseIdentifier: "PostNewsCell")
        
        navigationController?.navigationBar.setBackgroundImage(allNavigationBarAttributes.allNavigationbarBg, for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let verticalIndicator = PostNewsTableView.subviews.last as? UIImageView

        verticalIndicator?.backgroundColor = UIColor.darkGray

        self.PostNewsTableView.flashScrollIndicators()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let PostNewsCell = tableView.dequeueReusableCell(withIdentifier: "PostNewsCell", for: indexPath) as! PostNewsTableViewCell
        // FinCusImgView 陰影顏色
        PostNewsCell.FinCusImgView.layer.shadowColor = UIColor.black.cgColor
        // FinCusImgView 陰影位置
        PostNewsCell.FinCusImgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // FinCusImgView 陰影透明度
        PostNewsCell.FinCusImgView.layer.shadowOpacity = 0.5
        
        PostNewsCell.weatherCellLabel.text = PostData[0]
        
        PostNewsCell.trafficCellLabel.text = PostData[1]
        
        PostNewsCell.decideTagCellLabel.text = PostData[2]
        
        PostNewsCell.locationCellLabel.text = PostData[3]
        
        return PostNewsCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.NewsSelectedIndex = indexPath
        
        self.didPostExpanCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(PostisExpanded && self.NewsSelectedIndex == indexPath) {
            return 400
            
        }
        
        return 223
        
    }
    
    func didPostExpanCell() {
        self.PostisExpanded = !PostisExpanded
        
        self.PostNewsTableView.reloadRows(at: [NewsSelectedIndex!], with: .automatic)
        
    }
    // 製作 PostNewsTableView 陰影效果
    func PostNewsContainerView() {
        // PostNewsTableView 框線顏色
        PostNewsTableView.layer.borderColor = UIColor.black.cgColor
        // PostNewsTableView 框線寬度
        PostNewsTableView.layer.borderWidth = 1.0
        // 做出一個 UIView，與 PostNewsTableView 大小一樣
        let PostContainerView: UIView = UIView(frame: self.PostNewsTableView.frame)
        // PostContainerView 背景顏色設定，沒有背景顏色，效果可能不明顯，
        PostContainerView.backgroundColor = UIColor.blue
        // PostContainerView 設置圓角，與 PostNewsTableView 一起配合
        PostContainerView.layer.cornerRadius = 5
        // PostContainerView 陰影顏色
        PostContainerView.layer.shadowColor = UIColor.black.cgColor
        // PostContainerView 陰影向左偏移，為負數(x, y)
        PostContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        // PostContainerView 右邊陰影效果，為正數(x, y)
        // PostContainerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        // PostContainerView 陰影透明度
        PostContainerView.layer.shadowOpacity = 1
        // PostContainerView 陰影半徑
        PostContainerView.layer.shadowRadius = 10
        // PostNewsTableView 設置圓角
        PostNewsTableView.layer.cornerRadius = 5
        // PostNewsTableView 上使用
        PostNewsTableView.layer.masksToBounds = true
        
        self.view.addSubview(PostContainerView)
        
        self.view.addSubview(PostNewsTableView)
        
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
