//
//  NewsFeedTableViewCell.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/10/5.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherCellLabel: UILabel!
    
    @IBOutlet weak var trafficCellLabel: UILabel!
    
    @IBOutlet weak var decideTagCellLabel: UILabel!
    
    @IBOutlet weak var locationCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
