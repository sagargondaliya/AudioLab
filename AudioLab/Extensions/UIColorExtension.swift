//
//  UIColorExtension.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/8/18.
//  
//

import Foundation
import UIKit

extension UIColor {
    
    /// init color using RGBA values
    convenience init(red: Int, green: Int, blue: Int, alpha : CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
}
