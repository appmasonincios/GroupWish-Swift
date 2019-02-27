//
//  Networking.swift
//  Imobpay
//
//  Created by Arvind Mehta on 30/05/17.
//  Copyright © 2017 Arvind. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON



func executePOSTLogin(view:UIView,path:String, parameter:Parameters , completion: @escaping (JSON) -> ()) {
    
    view.makeToastActivity(.center)
    Alamofire.request(path,method: .post, parameters: parameter, encoding: URLEncoding.default,headers: nil).validate().responseJSON { response in
        
        view.hideToastActivity()
        
        switch response.result {
        case .success:
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{
                
            }
        case .failure:
            do {
                try completion(JSON(data: response.data!))
            }catch{
                
            }
            
        }
    }
}


func executePOST(view:UIView,path:String, parameter:Parameters , completion: @escaping (JSON) -> ()) {
    let headers = [
        "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
    view.makeToastActivity(.center)
    Alamofire.request(path,method: .post, parameters: parameter, encoding: URLEncoding.default,headers: headers).validate().responseJSON { response in
        
        view.hideToastActivity()
        
        switch response.result {
        case .success:
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{
                
            }
        case .failure:
            do {
                try completion(JSON(data: response.data!))
            }catch{
                
            }
            
        }
    }
}



func executeGET(view:UIView,path:String , completion: @escaping (JSON) -> ()) {
    view.makeToastActivity(.center)
    let headers = [
        "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
    
    Alamofire.request(path,method: .get,  encoding: JSONEncoding.default,headers:headers).validate().responseJSON { response in
        view.hideToastActivity()
        switch response.result {
        case .success:
          
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{
                
            }
        case .failure:
          
            do {
                try completion(JSON(data: NSData() as Data))
            }catch{
                
            }
        }
    }
    
}

func executeGETHEADER(view:UIView,path:String , completion: @escaping (JSON) -> ()) {
    
    view.makeToastActivity(.center)
    let headers = [
        "Authorization": getSharedPrefrance(key:Constants.TOKEN)]
    print(headers)
    
    Alamofire.request(path,method: .get,  encoding: JSONEncoding.default,headers:headers).validate().responseJSON { response in
        switch response.result {
        case .success:
            view.hideToastActivity()
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{
                
            }
        case .failure:
            view.hideToastActivity()
            do {
                try completion(JSON(data: NSData() as Data))
            }catch{
                
            }
        }
    }
    
}


func executePOSTWITHHEADER(view:UIView,path:String, parameter:Parameters , completion: @escaping (JSON) -> ()) {
    
    view.makeToastActivity(.center)
    
        let headers = [
           "token": getSharedPrefrance(key:Constants.TOKEN),
          "Content-Type": "application/x-www-form-urlencoded"]
    
    Alamofire.request(path,method: .post, parameters: parameter, encoding: URLEncoding.default,headers:headers).validate().responseJSON { response in
        view.hideToastActivity()
        switch response.result {
        case .success:
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{
                
            }
            
        case .failure:
            do {
                try completion(JSON(data: NSData() as Data))
            }catch{
                
            }
            
        }
    }
}


func executePOSTWITHHEADER1(view:UIView,path:String, parameter:Parameters , completion: @escaping (JSON) -> ()) {
    
    view.makeToastActivity(.center)
    
    Alamofire.request(path,method: .post, parameters: parameter, encoding: URLEncoding.default,headers:nil).validate().responseJSON { response in
        view.hideToastActivity()
        switch response.result {
        case .success:
            do {
                let jsonData = try JSON(data: response.data!)
                completion(jsonData)
            }catch{

            }

        case .failure:
            do {
                try completion(JSON(data: NSData() as Data))
            }catch{

            }

        }
    }
    

    
    
    
    
}







//
//func displayImage(imageView:UIImageView,path:String)
//{
//    imageView.contentMode = UIView.ContentMode.scaleAspectFit
//    imageView.image = UIImage(named: "loading-gear")
//    Alamofire.request(path).responseData { response in
//
//
//        if let image = response.result.value {
//            print("image downloaded: \(image)")
//            imageView.image = image
//        }
//    }
//
//
//}







func blurImage(image:UIImage) -> UIImage? {
    
    
    let context = CIContext(options: nil)
    let inputImage = CIImage(image: image)
    let originalOrientation = image.imageOrientation
    let originalScale = image.scale
    
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter?.setValue(10.0, forKey: kCIInputRadiusKey)
    let outputImage = filter?.outputImage
    
    var cgImage:CGImage?
    
    if let asd = outputImage
    {
        cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
    }
    
    if let cgImageA = cgImage
    {
        return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
    }
    
    return nil
}









