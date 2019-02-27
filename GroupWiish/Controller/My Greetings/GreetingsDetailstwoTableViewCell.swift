//
//  GreetingsDetailstwoTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class GreetingsDetailstwoTableViewCell: UITableViewCell {

    @IBOutlet weak var heightoftop: NSLayoutConstraint!
    @IBOutlet weak var videostatus: UILabel!
    @IBOutlet weak var backview:UIView!
    @IBOutlet weak var friendname: UILabel!
    @IBOutlet weak var friendimage: ImageViewDesign!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
