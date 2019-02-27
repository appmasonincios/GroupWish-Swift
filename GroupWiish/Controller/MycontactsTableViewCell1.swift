//
//  MycontactsTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class MycontactsTableViewCell1: UITableViewCell {

    @IBOutlet weak var deleteAction: UIButton!
    @IBOutlet weak var contactimage: ImageViewDesign!
    
    @IBOutlet weak var contectname: UILabel!
    
    @IBOutlet weak var contactplacelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
