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



func executePOST(view:UIView,path:String, parameter:Parameters , completion: @escaping (JSON) -> ()) {
    
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



func executeGET(view:UIView,path:String , completion: @escaping (JSON) -> ()) {
    view.makeToastActivity(.center)
    
    print(Constants.LIVEURL+path)
    Alamofire.request(path,method: .get,  encoding: JSONEncoding.default,headers:nil).validate().responseJSON { response in
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
//    let headers = [
//
//        "x-access-token": getSharedPrefrance(key:Constants.USER_TOKEN),
//        "Content-Type": "application/x-www-form-urlencoded" ]
    Alamofire.request(Constants.LIVEURL+path,method: .get,  encoding: JSONEncoding.default,headers:nil).validate().responseJSON { response in
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

//func displayImage(imageView:UIImageView,path:String){
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

//func displayImage(imageView:UIImageView,blurr:UIImageView,path:String){
//    imageView.contentMode = UIView.ContentMode.scaleAspectFit
//    imageView.image = UIImage(named: "loading-gear")
//    Alamofire.request(path).responseImage { response in
//        //            debugPrint(response)
//        //
//        //            print(response.request)
//        //            print(response.response)
//        //            debugPrint(response.result)
//
//        if let image = response.result.value {
//            print("image downloaded: \(image)")
//
//            imageView.image = image
//            imageView.layer.borderWidth = 1
//            imageView.layer.masksToBounds = false
//            imageView.layer.borderColor = UIColor.black.cgColor
//            imageView.layer.cornerRadius = imageView.frame.height/2
//            imageView.clipsToBounds = true
//            DispatchQueue.global(qos: .background).async {
//                let img = blurImage(image: image)
//
//                DispatchQueue.main.async {
//                     blurr.image = img
//                }
//            }
//
//
//        }else{
//          imageView.image = UIImage(named: "women")
//            imageView.layer.borderWidth = 1
//            imageView.layer.masksToBounds = false
//            imageView.layer.borderColor = UIColor.black.cgColor
//            imageView.layer.cornerRadius = imageView.frame.height/2
//            imageView.clipsToBounds = true
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









