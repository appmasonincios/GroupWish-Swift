//
//  ArrangeVideosViewController.swift
//  GroupWiish
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire
import ViewAnimator
import AVFoundation
import AVKit
import PopItUp
import MobileCoreServices
import CoreFoundation
class ArrangeVideosViewController: UIViewController {
    @IBOutlet weak var gradientview: GradientView!
    var videosArray = [Greeting_VideosModelClass]()
    var selectedArray = [Greeting_VideosModelClass]()
    var greeting_id = ""
    var selectedVideosArray = [Greeting_VideosModelClass]()
    var booleancheck:Bool = false
    var searchedArray = [Greeting_VideosModelClass]()
    @IBOutlet weak var searchView: GradientView!
    @IBOutlet var searchtextfield: UITextField!
    
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var mergeVideosBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longGR.minimumPressDuration = 0.1
        videosCollectionView.addGestureRecognizer(longGR)
        
        gradientview.colors = [
            UIColor(red: 91.0/255.0, green: 37.0/255.0, blue: 91.0/255.0, alpha: 1),
            UIColor(red: 111.0/255.0, green: 63.0/255.0, blue: 111.0/255.0, alpha: 1)]
        
        //  self.searchtextfield.delegate = self
        self.searchtextfield.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        self.selectedVideosArray = selectedArray
        
        self.videosCollectionView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
      
    }
    @objc func searchRecordsAsPerText(_ textfield:UITextField)
    {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0
        {
            for strCountry in self.selectedVideosArray
            {
                let str = strCountry.friend_name
                let range = str?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                if range != nil
                {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = self.selectedVideosArray
        }
        
        videosCollectionView.reloadData()
    }
   
    
    @IBAction func searchbuttonaction(_ sender: Any)
    {
        booleancheck = true
        self.searchView.isHidden = false
    }
    @IBAction func cancelbuttonaction(_ sender: Any)
    {
        booleancheck = false
        self.searchView.isHidden = true
        self.videosCollectionView.reloadData()
    }
    
    @IBAction func mergeAction1(_ sender: Any)
    {
        if selectedVideosArray.count >= 2
        {
            var stringVideos = [String]()
            for dic in self.selectedVideosArray
            {
                if let value = dic.id
                {
                    stringVideos.append(value)
                }
            }
            var parameters = [String:Any]()
          let string = stringVideos.joined(separator: ",")
            parameters["video_ids"] = string
            parameters["type"] = "free"
            tag_videosforMerge(parameters:parameters)

        } else {
            Shared.sharedInstance().showToast(withMessage: "Atleast two videos required.", onVc: self, type: "2")
        }
    }

    
    func tag_videosforMerge(parameters:[String:Any])
    {
      //  Tag_videosforMerge
        
        executePOST(view: self.view, path: Constants.LIVEURL + Constants.merge_videos, parameter:parameters){ response in
            let status = response["status"].int
            if(status == Constants.SUCCESS_CODE)
            {
                let preview = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewControllern") as! PreviewViewControllern
                if let object = response["result"].string
                {
                    preview.url = URL(string: "\(Constants.WS_VideoUrl)/\(object)")
                    preview.sendUrl = object
                }
                preview.greeting_id = self.greeting_id
                    self.navigationController?.pushViewController(preview, animated: true)
               
            }
            else
            {
                self.showToast(message:response["errors"].string ?? "")
            }
        }
        
        
        
    }
    
    @IBAction func backbuttonaction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated:false)
    }

    
    @objc func cancelBtnAction(_ sender: UIButton?) {
        videosCollectionView.performBatchUpdates({
            
            self.selectedVideosArray.remove(at: sender?.tag ?? 0)
            let indexPath = IndexPath(row: sender?.tag ?? 0, section: 0)
            self.videosCollectionView.deleteItems(at: [indexPath])
            
        }) { finished in
            
            self.videosCollectionView.reloadData()
        }
    }

    @objc func playBtnAction(_ sender: UIButton?) {
        var player: AVPlayer? = nil
        if let accessibilityHint = sender?.accessibilityHint, let url = URL(string: "\(Constants.WS_VideoUrl)/\(accessibilityHint)")
        {
            player = AVPlayer(url: url)
        }
        
        let controller = AVPlayerViewController()
        present(controller, animated: true)
        controller.player = player
        player?.play()
    }

    func removeVideo(atPath filePath: URL?) {
        var stringPath: String? = nil
        if let filePath = filePath {
            stringPath = "\(filePath)"
        }
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: stringPath ?? "") {
            try? fileManager.removeItem(atPath: stringPath ?? "")
        }
    }
    
    //#pragma Custom Methods
    @objc func handleLongPress(_ gr: UILongPressGestureRecognizer?) {
        switch gr?.state {
        case .began?:
            let selectedIndexPath: IndexPath? = videosCollectionView.indexPathForItem(at: gr?.location(in: videosCollectionView) ?? CGPoint.zero)
            if selectedIndexPath == nil {
            }
            if let selectedIndexPath = selectedIndexPath {
                videosCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed?:
            videosCollectionView.updateInteractiveMovementTargetPosition(gr?.location(in: gr?.view) ?? CGPoint.zero)
        case .ended?:
            videosCollectionView.endInteractiveMovement()
        default:
            videosCollectionView.cancelInteractiveMovement()
        }
    }
}

extension ArrangeVideosViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if booleancheck == false
        {
            return self.selectedVideosArray.count
        }
        else
        {
            return searchedArray.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:ArrangeVideosCollectionViewCelln = collectionView.dequeueReusableCell(withReuseIdentifier:"ArrangeVideosCollectionViewCelln", for:indexPath) as! ArrangeVideosCollectionViewCelln
        
        cell.layer.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1).cgColor
        
         var greeting_VideosModelClass:Greeting_VideosModelClass? = nil
        
        if booleancheck == false
        {
             greeting_VideosModelClass = self.selectedVideosArray[indexPath.row]
        }
        else
        {
           greeting_VideosModelClass = self.searchedArray[indexPath.row]
        }
        
        cell.userName?.text = greeting_VideosModelClass?.friend_name

        cell.playBtn.accessibilityHint = greeting_VideosModelClass?.video_name
        
        cell.playBtn.addTarget(self, action: #selector(self.playBtnAction(_:)), for: .touchUpInside)
        
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(self.cancelBtnAction(_:)), for: .touchUpInside)
        
        if let constantName = greeting_VideosModelClass?.thumb_image
        {
            let imageURL = URL(string:Constants.WS_ImageUrl + "/" + constantName)!
            
            cell.tumbNail.kf.indicatorType = .activity
            cell.tumbNail.kf.setImage(with:imageURL)
            //statements using 'constantName'
        } else {
            // the value of someOptional is not set (or nil).
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width / 2, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let sourceDic:Greeting_VideosModelClass = selectedVideosArray[sourceIndexPath.row]
        selectedVideosArray.remove(at: sourceIndexPath.row)
        selectedVideosArray.insert(sourceDic, at:destinationIndexPath.row)
        videosCollectionView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
