//
//  ProgressView.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/8/18.
//
//

import UIKit

/**
 ProgressView
 */

class ProgressView: UIView {

    /// Animation Ket Constants
    let kRotationAnimationKey = "rotationanimationkey"
    let kProgressAnimateKey   = "ProgressAnimationKey"

    /// Properties
    private var progressLayer: CAShapeLayer?
    private var progressBackgroundLayer: CAShapeLayer?
    private var previousProgress : CGFloat = 0
    
    var progress : CGFloat = 0{
        didSet {
            self.animateProgress(progress)
        }
    }
    
    var progressColor : UIColor = UIColor.black {
        didSet {
            progressLayer?.strokeColor = progressColor.cgColor
        }
    }

    var lineWidth : CGFloat = 1 {
        didSet{
            self.progressLayer?.lineWidth = lineWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
    }
    
    /// Setup progressview with configuration
    func setupProgressView() {
        
        if progressLayer == nil {
            let progressPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(360.0.degreesToRadians), clockwise: true)
            
            progressBackgroundLayer = CAShapeLayer()
            progressBackgroundLayer!.frame = self.bounds
            progressBackgroundLayer!.path = progressPath.cgPath
            progressBackgroundLayer!.fillColor = UIColor.clear.cgColor
            progressBackgroundLayer!.strokeColor = UIColor.white.cgColor
            progressBackgroundLayer!.lineWidth = lineWidth;
            progressBackgroundLayer!.strokeEnd = 0.0
            
            self.layer.addSublayer(progressBackgroundLayer!)
            self.transform = CGAffineTransform(rotationAngle: CGFloat(270.0.degreesToRadians));
            
            progressLayer = CAShapeLayer()
            progressLayer!.frame = self.bounds
            progressLayer!.path = progressPath.cgPath
            progressLayer!.fillColor = UIColor.clear.cgColor
            progressLayer!.strokeColor = progressColor.cgColor
            progressLayer!.lineWidth = lineWidth;
            progressLayer!.strokeEnd = 0.0
            
            self.layer.addSublayer(progressLayer!)
            self.transform = CGAffineTransform(rotationAngle: CGFloat(270.0.degreesToRadians));
            
            
        }
    }
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupProgressView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressView()
    }
    
    /// Animate Progress
    func animateProgress(_ progress: CGFloat) {
        
        if progress < 0 {
            selfRotation()
            progressLayer!.strokeEnd = 0
            return;
        }
        if progress == 0 {
            progressLayer!.strokeEnd = 0
            return;
        }
        
        if progressBackgroundLayer?.animation(forKey: kRotationAnimationKey) != nil {
            progressBackgroundLayer!.removeAnimation(forKey: kRotationAnimationKey)
            progressBackgroundLayer!.strokeEnd = 1.0
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.fromValue = previousProgress
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        progressLayer!.strokeEnd = CGFloat(progress)
        
        progressLayer!.add(animation, forKey: kProgressAnimateKey)
        previousProgress = progress;
           
    }
    
    /// Rotate animation
    func selfRotation() {
        
        progressBackgroundLayer?.strokeEnd = 0.7
        
        if progressBackgroundLayer?.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = 360.0.degreesToRadians
            rotationAnimation.duration = 2
            rotationAnimation.repeatCount = Float.infinity
            
            progressBackgroundLayer?.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    /// Reset Progress
    func reset() {
        progress = 0;
        previousProgress = 0;
    }
    
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
