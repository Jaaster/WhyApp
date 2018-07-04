//
//  UIImageExtension.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/27/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit
extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
