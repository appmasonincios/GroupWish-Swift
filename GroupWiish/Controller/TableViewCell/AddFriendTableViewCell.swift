//
//  AddFriendTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var addfriendbutton: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var grettingprofileimage: ImageViewDesign!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
