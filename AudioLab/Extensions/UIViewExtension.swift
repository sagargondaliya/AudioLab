//
//  UIViewExtension.swift
//  ECommerceApp
//
//  Created by Sagar Gondaliya on 12/03/18.
//  Copyright © 2018 Gondaliya, Sagar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// This function sets corner radius for UIView
    func setCornerRadius(radius: Float) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    /// This function makes view to rounded
    func roundedView() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    /// This function sets view's border width
    func setBorderWidth(width: Float) {
        self.layer.borderWidth = CGFloat(width)
    }
    
    /// This function sets border color
    func setBorderColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
    /// This function sets view's border width and color
    func setBorderWidth(width: Float, color: UIColor) {
        setBorderWidth(width: width)
        setBorderColor(color: color)
    }
}
