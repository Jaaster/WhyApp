//
//  UIImageCollectionViewCell.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/5/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class UIImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
