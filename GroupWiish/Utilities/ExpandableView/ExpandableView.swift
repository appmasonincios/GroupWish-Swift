//
//  ExpandableView.swift
//  GroupWiish
//
//  Created by apple on 09/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit

class ExpandableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

}
