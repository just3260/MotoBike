//
//  firstStartAppViewController.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/8/28.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class firstStartAppViewController: UIViewController, UIScrollViewDelegate, FBKeyinDelegate {
    
    fileprivate var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var firstLoginBtn: UIButton!
    
    @IBOutlet weak var visitorBtn: UIButton!
    
    let FBModel = FBDataManager();
    
    // 畫面 Page 頁數
    // private 與 fileprivate，private 是在宣告內的區塊才可取得， fileprivate 是在宣告的 SourceFile 內，都可以取得
    fileprivate let numPages = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 將 View 相對於在自己身上，
        let frame = self.view.bounds
        // 透過 UIScrollView 屬性，將 View 指定為 UIScrollView
        // UIScrollView(frame: ): 是繼承 CALayer class，主要是注重於內容的繪製，不是拿來當事件的處禮
        scrollView = UIScrollView(frame: frame)
        // 會自動滾到 View.bounds 的邊界
        scrollView.isPagingEnabled = true
        // 不顯水平滾動條
        scrollView.showsHorizontalScrollIndicator = false
        // 不顯示垂直滾動條
        scrollView.showsVerticalScrollIndicator = false
        // 不觸碰狀態欄，回到 View 最頂端
        scrollView.scrollsToTop = false
        // 讓頁面重覆來回
        scrollView.bounces = false
        // 原點座標為 (0.0)，內容左上角與 ScrollView 的間距值
        scrollView.contentOffset = CGPoint.zero
        // ScrollView 滾動區域大小
        // 將 ScrollView 的 contentSize 設為螢幕寬度的3倍(根據實際情況改變)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numPages), height: frame.size.height)
        
        scrollView.delegate = self
        
        for index in 0..<numPages {
            // 透過尋訪，每到下一張 +1
            let pageImg = UIImageView(image: UIImage(named: "MotoBike GuideView\(index + 1)"))
            // 製作 ImageView 框架，X位置 設為螢幕寬度的 3 倍
            pageImg.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            // scrollView 貼到畫面最上層
            scrollView.addSubview(pageImg)
            
        }
        // 將 scrollView 指定到 第0層
        // addSubview: 只會貼到畫面最上層
        // insertSubview: 控制 View 可以添加到第幾個頁面層
        // 0最底層
        self.view.insertSubview(scrollView, at: 0)
        // firstLoginBtn 按鈕設置圓角
        firstLoginBtn.layer.cornerRadius = 15.0
        
        visitorBtn.layer.cornerRadius = 15.0
        // 隱藏 firstLoginBtn 按鈕
        firstLoginBtn.alpha = 0.0
        
        visitorBtn.alpha = 0.0
        // Do any additional setup after loading the view.
        // FBManager 的協定簽到 firstStartAppViewController
        FBModel.FBLogin = self
        
        FBModel.getUserData()
        
    }
    // 隱藏狀態欄(Status Bar)
    override var prefersStatusBarHidden : Bool {
        return true
        
    }
    // MARK: UIScrollViewDelegate 實作方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 隨著滑動改變 pageControl 的狀態
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        // 因為 currentPage 是從0開始算，所以 numOfPages 减1
        if pageControl.currentPage == numPages - 1  {
            UIView.animate(withDuration: 0.5, animations: {
                self.firstLoginBtn.alpha = 1.0
                
                self.visitorBtn.alpha = 1.0
                
            })
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.firstLoginBtn.alpha = 0.0
                
                self.visitorBtn.alpha = 0.0
                
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 將抓取顯示的陣列用自訂 Delegate，傳值
    func FBLoginData(LoginKey: [String]) {
        
        // 將User FB Data 存進 UserDefaults
        UserDefaults.standard.set(LoginKey, forKey: "FBData")
        
        UserDefaults.standard.synchronize()
        // 跳轉至Map畫面
        let SideVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "HostViewController")
        SideVC.modalTransitionStyle = .crossDissolve
        present(SideVC, animated: true, completion: nil)

    }
    
    // FB 登入按鈕
    @IBAction func FBLoginActionBtn(_ sender: UIButton) {
        // 登入方法
        let LoginManager = FBSDKLoginManager()
        
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                
            } else {
                self.FBModel.getUserData()
                
            }
            
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
