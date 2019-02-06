//
//  LabelDesign.swift
//  FittCube
//
//  Created by osvinuser on 15/10/18.
//  Copyright © 2018 Osvin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LabelDesign: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderwidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderwidth
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

