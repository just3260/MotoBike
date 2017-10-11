//
//  MenuTableCell.swift
//  MotoBike
//
//  Created by XD.Mac on 2017/10/6.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var menuSwitchOutlet: UISwitch!
    
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // Pin開關
    @IBAction func menuSwitch(_ sender: UISwitch) {
        let gasStationPin = menuSwitchOutlet.isOn
        
        if menuLabel.text == "Gas Station" {
            
            if gasStationPin == true {
                let gasOnNotification = Notification.Name(rawValue:"GASON")
                NotificationCenter.default.post(name: gasOnNotification, object: nil, userInfo: nil)
            } else {
                let gasOffNotification = Notification.Name(rawValue:"GASOFF")
                NotificationCenter.default.post(name: gasOffNotification, object: nil, userInfo: nil)
            }
            
        } else if menuLabel.text == "Parking" {
            
            if gasStationPin == true {
                let parkingOnNotification = Notification.Name(rawValue:"PARKINGON")
                NotificationCenter.default.post(name: parkingOnNotification, object: nil, userInfo: nil)
            } else {
                let parkingOffNotification = Notification.Name(rawValue:"PARKINGOFF")
                NotificationCenter.default.post(name: parkingOffNotification, object: nil, userInfo: nil)
            }
        }

    }
    
    
    
}
