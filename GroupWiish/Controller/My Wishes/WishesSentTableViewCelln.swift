//
//  WishesSentTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 12/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class WishesSentTableViewCelln: UITableViewCell {

    
    @IBOutlet weak var profileimage: ImageViewDesign!
    @IBOutlet weak var thumb_image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var friend_name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var downloadbutton: UIButton!
    @IBOutlet weak var playbutton1: UIButton!
    
    @IBOutlet weak var viewimage: UIButton!
    @IBOutlet weak var play: UIButton!
    
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var viewimageview: ViewDesign!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
