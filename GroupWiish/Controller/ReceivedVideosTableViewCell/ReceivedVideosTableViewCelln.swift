//
//  ReceivedVideosTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 22/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class ReceivedVideosTableViewCelln: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImage: ImageViewDesign!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var mainImage: ImageViewDesign!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
