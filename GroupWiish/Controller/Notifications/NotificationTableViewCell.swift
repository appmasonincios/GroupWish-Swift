//
//  NotificationTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var profileimage: ImageViewDesign!
    
    @IBOutlet weak var sendreplayview: ViewDesign!
    @IBOutlet weak var mainimage: ImageViewDesign!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var sendreplaybutton: UIButton!
    @IBOutlet weak var simpletextview: UITextView!
    @IBOutlet weak var timelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
