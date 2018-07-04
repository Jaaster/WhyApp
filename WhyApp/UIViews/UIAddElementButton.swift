//
//  AddElementUIButton.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/1/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class UIAddElementButton: UIButton {
    
    var delegate: AddElementUIButtonDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(addElement), for: .touchUpInside)
        
        setTitle("CREATE", for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        layer.cornerRadius = 40
        clipsToBounds = true
        backgroundColor = .fadedBlack
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addElement() {
        delegate?.addElement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(view: UIView, spacing: CGFloat) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing).isActive = true
        heightAnchor.constraint(equalToConstant: 75).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.width/3*2).isActive = true
        bounds = CGRect(x: 0, y: 0, width: view.frame.width / 3, height: 75)
    }
}

protocol AddElementUIButtonDelegate {
    func addElement()
}
