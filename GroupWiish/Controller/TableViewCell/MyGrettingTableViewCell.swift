//
//  MyGrettingTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 11/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class MyGrettingTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfVideosBtn: UIButton!
    @IBOutlet weak var grettingprofileimage: ImageViewDesign!
    
    @IBOutlet weak var profilename: UILabel!
    
    @IBOutlet weak var mainimage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timelabel: UILabel!
    
    @IBOutlet weak var countlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
