//
//  RequestViewTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 19/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class RequestViewTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
