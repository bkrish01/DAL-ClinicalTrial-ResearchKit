//
//  MyDeviceTableViewCell.swift
//  Patient ePRO
//
//  Created by Krishnapillai, Bala on 2/9/16.
//  Copyright © 2016 AMGEN. All rights reserved.
//

import UIKit

class MyDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eQuestion: UILabel!
    // MARK: Properties
    @IBOutlet weak var eYes: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

