//
//  ActivityLoader.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/8/18.
//
//

import Foundation
import UIKit

/**
 ActivityLoader - Activity Indicator
 */
final class ActivityLoader{
 
    /// Singleton
    static let share = ActivityLoader()
    
    /// Properties
    private var activityView : UIView!
    
    /// Initializer
    private init() {
        
        /// Activity Indicator View Configuration
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        indicator.startAnimating()
        
        activityView = UIView(frame: UIScreen.main.bounds)
        activityView.backgroundColor = UIColor.clear
        activityView.layer.cornerRadius = 10
        activityView.addSubview(indicator)
        indicator.layer.cornerRadius = 10
        indicator.center = CGPoint(x: activityView.frame.width / 2, y: activityView.frame.height / 2)
        
    }
    
    /// To show activity view
    static func showActivityView(){
        if let activityView = ActivityLoader.share.activityView {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                DispatchQueue.main.async {
                    window.addSubview(activityView)
                    activityView.center = CGPoint(x: window.frame.width / 2, y: window.frame.height / 2)
                }
            }
        }
    }
    
    /// To hide activity view
    static func hideActivityView(){
        if let activityView = ActivityLoader.share.activityView {
            DispatchQueue.main.async {
                activityView.removeFromSuperview()
            }
        }
    }
    
}


