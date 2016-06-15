//
//  UIImageHelper.swift
//  mominion
//
//  Created by SarkozyTran on 6/15/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

