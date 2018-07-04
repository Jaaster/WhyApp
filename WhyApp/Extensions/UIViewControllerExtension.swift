//
//  UIViewControllerExtension.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/28/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

extension UIViewController {
    func promptUser(with message: String) {
        let label = UILabel()
        label.alpha = 0
        label.text = message
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .autoreverse, animations: {
            label.alpha = 1
        }, completion: { _ in
            label.alpha = 0
        })
    }
}
