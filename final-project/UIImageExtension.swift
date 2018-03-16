//
//  UIImageExtension.swift
//  Photo Phabulous
//
//  Created by Jerry Lo on 2/25/18.
//  Copyright © 2018 Jerry Lo. All rights reserved.
//
// Attributions: https://gist.github.com/tomasbasham/10533743

import Foundation
import UIKit

extension UIImage {
    // Scale mode (like Content Mode)
    enum ScaleMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - oldSize: the old size used to calculate the ratio
        ///     - newSize: the new size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between oldSize: CGSize, and newSize: CGSize) -> CGFloat {
            let aspectWidth  = newSize.width/oldSize.width
            let aspectHeight = newSize.height/oldSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }

    func resize(by scale: CGFloat) -> UIImage {
        let newSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    func resize(to newSize: CGSize, scaleMode: UIImage.ScaleMode = .aspectFill) -> UIImage {
        let aspectRatio = scaleMode.aspectRatio(between: size, and: newSize)
        let calculatedSize = size.applying(CGAffineTransform(scaleX: aspectRatio, y: aspectRatio))
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(calculatedSize)
        draw(in: CGRect(origin: CGPoint.zero, size: calculatedSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
