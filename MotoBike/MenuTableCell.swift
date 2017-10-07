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
    
    @IBOutlet weak var menuSwitch: UISwitch!
    
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
