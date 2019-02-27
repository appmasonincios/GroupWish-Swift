//
//  MyVideoTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 11/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class MyVideoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var thumb_image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var friend_name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var downloadbutton: UIButton!
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var videobutton: UIButton!
    
    @IBOutlet weak var replaybuttonaction: UIButton!
    
    @IBOutlet weak var replayview: ViewDesign!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
