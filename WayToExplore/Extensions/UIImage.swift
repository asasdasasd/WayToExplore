//
//  UIImage.swift
//  WayToExplore
//
//  Created by shen on 2017/8/9.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
    
    //https://onevcat.com/2013/04/using-blending-in-ios/
    func imageWithTintColor(_ tintColor: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        tintColor.setFill()
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(rect)
        
        draw(in: rect, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != .destinationIn {
            draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

