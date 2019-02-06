//
//  Extension+ViewControllers.swift
//  FittCube
//
//  Created by osvinuser on 16/10/18.
//  Copyright © 2018 Osvin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
extension UIViewController
{
    func hideLoader(view: UIView) {
        
        DispatchQueue.main.async(execute: {
            //Indicator.sharedInstance.hideIndicator()
            
            MBProgressHUD.hide(for: view, animated: true)
            
        })
    }
    
    func showLoader(view: UIView) {
        
        DispatchQueue.main.async(execute: {
            //Indicator.sharedInstance.showIndicator()
            MBProgressHUD.showAdded(to: view, animated: true)
        })
        
    }
    
    
    struct AppConstants
    {
        static let appDelegete = UIApplication.shared.delegate as! AppDelegate
    }
   
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
  
    func checkstate(checkstate:String) -> String
    {
        let state:String = checkstate
        print(state)
    
        
        return state
    }
    
    
    func getDateFormatterFromServer(stringDate: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringDate)
        return date
    }

    
    //MARK: - Alert Methods
    internal func showAlertView(title OfAlert:String, message OfBody:String) {
        
        let alertController = UIAlertController(title: OfAlert, message: OfBody, preferredStyle: .alert)
        let someAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(someAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //toast
    
    internal func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 100, height: 60))
        toastLabel.center = self.view.center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 3
        //toastLabel.font = constantsNaming.fontType.kOpenSans_RegularMedium
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.isHidden = true
        })
    }
    
    internal func setGradientColorToView(view : AnyObject, hexString1:String, hexString2:String) {
        
        /// Step 1 set the colors which you want to show in the view /
        //        let colorTop = UIColor().hexStringToUIColor(hex: hexString1)
        //        let colorBottom = UIColor().hexStringToUIColor(hex: hexString2)
        
        /// Step 2 create the gradient layer, add the colors and set the frame /
        let gradient: CAGradientLayer = CAGradientLayer()
        //      gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0, 0.7]
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK: - Convert Date to String
    internal func convertDateToString(instance OfDate:Date, instanceOf DateFormat:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        return dateFormatter.string(from:OfDate)
    }
    
    //MARK: - Convert String to Date
    internal func convertStringToDate(dateofString:String,DateFormat:String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateofString)// create   date from string
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp =  dateFormatter.date(from: dateofString)
        return  timeStamp ?? Date()
        
    }
    
    internal func convertStringDateToLocal(dateofString:String/*,DateFormat:String*/) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        let date = dateFormatter.date(from: dateofString)
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date ?? Date())
        
        return timeStamp
    }
    
    func convertstringToDate(stringDate: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        let date = dateFormatter.date(from: stringDate)
        
        if let dateObject = date {
            return dateObject // return the date if date is not equal to null
        }
        
        return date
        
    }
    
    //MARK: - Keyboard Hide Method
    internal func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc internal func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func backbuttonaction()
    {
        
        self.navigationController?.popViewController(animated:false)
        
        
    }
    func addNavBarImage()
    {
        let image = UIImage(named: "ic_logo") //Your logo url here
        let imageView = UIImageView(image: image)
        imageView.sizeToFit()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(backbuttonaction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        let sliderImage = UIImage(named: "ic_cross_black")
        navigationItem.leftBarButtonItem?.image = sliderImage
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationItem.titleView = imageView
    }
    
    func addNavBarImagediffrentimage()
    {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(backbuttonaction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        let sliderImage = UIImage(named: "ic_arrow_backward")
        navigationItem.leftBarButtonItem?.image = sliderImage
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func getCurrentTimeZone() -> String{
        
        return String (TimeZone.current.identifier)
        
    }
}

extension UITableViewCell
{
    internal func simplemethod(heartbeatrate:String)
    {
      print(heartbeatrate)
        myComputedProperty = heartbeatrate
    }
    
    struct Holder
    {
        static var _myComputedProperty:String = ""
    }
    var myComputedProperty:String {
        get
        {
            return Holder._myComputedProperty
        }
        set(newValue)
        {
            Holder._myComputedProperty = newValue
        }
    }
}

extension UILabel
{
    func setText() -> String
    {
        myComputedProperty = self.text!
    return self.text ?? ""
    }
    
    struct Holder
    {
        static var _myComputedProperty:String = ""
    }
    var myComputedProperty:String {
        get
        {
            return Holder._myComputedProperty
        }
        set(newValue)
        {
            Holder._myComputedProperty = newValue
        }
    }
}

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -1
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }

extension String {
    func numberOfSeconds() -> Int {
        var components: Array = self.components(separatedBy: ":")
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[1]) ?? 0
        let seconds = Int(components[2]) ?? 0
        return (hours * 3600) + (minutes * 60) + seconds
    }
}

extension UIView {
    
    
    /* Usage Example
     * bgView.addBottomRoundedEdge(desiredCurve: 1.5)
     */
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
}
