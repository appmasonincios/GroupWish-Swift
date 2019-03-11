//
//  TextFieldDesign.swift
//  FittCube
//
//  Created by osvinuser on 15/10/18.
//  Copyright © 2018 Osvin. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldDesign: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    @IBInspectable var leftAddView: CGRect = CGRect.zero
    @IBInspectable var leftimageView: CGRect = CGRect.zero
    
    @IBInspectable var rightAddView: CGRect = CGRect.zero
    @IBInspectable var rightimageView: CGRect = CGRect.zero
    
    
    @IBInspectable var placeHolderColor: UIColor? {
     get {
            return self.placeHolderColor
        }
        set
        {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
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
    
    @IBInspectable var shadowOffset : CGSize {
        get {
            return layer.shadowOffset;
        }
        set {
            layer.shadowOffset = newValue;
        }
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView()
    {
        if let image = leftImage
        {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    @IBInspectable var RightSideImage:UIImage? {
        didSet{
            
            let rightAddView = UIView(frame: self.rightAddView)
            let rightImageView = UIImageView(frame: self.rightimageView)//Create a imageView for left side.
            rightImageView.image = RightSideImage
            rightAddView.addSubview(rightImageView)
            self.rightView = rightAddView
            self.rightViewMode = UITextField.ViewMode.always
        }
        
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

