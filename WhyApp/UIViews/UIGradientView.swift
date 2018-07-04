//
//  BackgroundUIView.swift
//  WhyApp
//
//  Created by Joriah Lasater on 5/31/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class UIGradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.brightRed.cgColor, UIColor.darkRed.cgColor]
        layer.insertSublayer(newLayer, at: 0)
        newLayer.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
