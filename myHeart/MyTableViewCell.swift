//
//  MyTableViewCell.swift
//  myHeart
//
//  Created by Krishnapillai, Bala on 2/27/16.
//  Copyright © 2016 Shashank Kothapalli. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var answers: UILabel!
    @IBOutlet weak var Questions: UILabel!
    @IBOutlet weak var BtnYes: UIButton!
    @IBOutlet weak var BtnNo: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

