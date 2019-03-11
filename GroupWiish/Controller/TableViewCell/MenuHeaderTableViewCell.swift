//
//  MenuHeaderTableViewCell.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var layoutwidth: NSLayoutConstraint!
    @IBOutlet weak var userprofileimage: UIImageView!
    @IBOutlet weak var placelabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sidemenulayout()
        // Initialization code
    }
    
    
    func sidemenulayout()
    {
        let width = UIScreen.main.nativeBounds.width
        
        switch width
        {
        case 320:
            
            break
        case 375:
            
            break
        case 414:
            
            self.layoutwidth.constant = 0
            
            break
        default: break
            
        }
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
