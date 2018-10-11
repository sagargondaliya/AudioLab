//
//  AlertView.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/8/18.
//
//

import Foundation
import UIKit

/**
 AlertView - To present alert controller
 */
final class AlertView {
    
    /// Show alert with title and message
    class func showAlertWithTitle(_ title: String, message : String, viewController : UIViewController?){
        
        var visibleViewController : UIViewController?
        
        /// If view controller nil then get visible viewcontroller to present alertview
        if viewController == nil{
            visibleViewController = UIViewController.visibleViewControllerFromRootViewController((UIApplication.shared.keyWindow?.rootViewController)!)
        }
        
        /// AlertController with title and Message
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        /// Ok Action for Alert Controller
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        
        /// Add action to alertcontroller
        alertController.addAction(okAction)
        
        
        if let visibleVC = visibleViewController{
            DispatchQueue.main.async {
                /// present alert on viewcontroller
                visibleVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
