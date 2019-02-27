//
//  ViewController.swift
//  DownloadTaskWithNSURLSession
//
//  Created by Malek T. on 11/4/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import UserNotifications
class DownloadVC: UIViewController, URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate
{

    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var url:String = ""

    @IBAction func cancel(_ sender: AnyObject)
    {
        if downloadTask != nil{
            downloadTask.cancel()
        }
        dismiss(animated: true)
    }
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     let urlstr = getSharedPrefrance(key:"keyurl")
        
        if urlstr != ""
        {
            progressView.transform = progressView.transform.scaledBy(x: 1, y: 20)
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            progressView.setProgress(0.0, animated: false)
            
                let url = URL(string:urlstr)!
                downloadTask = backgroundSession.downloadTask(with: url)
                downloadTask.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showFileWithPath(path: String)
    {
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true
        {
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
    }
    
    //MARK: URLSessionDownloadDelegate
    // 1
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        
        let exc:String = "/" + randomString(length: 5) + "vid1.mov"
        
        print(exc)
        
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat(exc))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
        
         try? FileManager.default.removeItem(at: location)
    }
    
 
    // 2
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64)
    {
        progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
        progressView.setProgress(0.0, animated: true)
        if (error != nil) {
            print(error!.localizedDescription)
        }else
        {
             dismiss(animated: true)
            print("The task finished transferring data successfully")
        }
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
}


