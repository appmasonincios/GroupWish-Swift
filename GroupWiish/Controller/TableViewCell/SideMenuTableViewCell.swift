//
//  SideMenuTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menulabel: UILabel!
    @IBOutlet weak var menuimage: UIImageView!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    @IBInspectable var selectionColor: UIColor = UIColor.init(red:236.0/255.0, green: 220.0/255.0, blue:236.0/255.0, alpha:1.0)
        {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
        self.menulabel.backgroundColor = selectionColor
        
        self.menulabel.textColor = selectionColor
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
