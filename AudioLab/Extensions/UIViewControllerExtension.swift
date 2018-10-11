//
//  UIViewControllerExtension.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/8/18.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    /// returns top visible view controller
    static func visibleViewControllerFromRootViewController(_ rootViewController : UIViewController) -> UIViewController{
        
        var topViewController : UIViewController = rootViewController
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}

