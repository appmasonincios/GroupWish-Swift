//
//  GreetingsDetailsoneTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 17/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class GreetingsDetailsoneTableViewCell: UITableViewCell {

    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var eventimage: UIImageView!
    @IBOutlet weak var duetime: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
