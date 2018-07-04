//
//  XUIToolbar.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/3/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class ToolbarItems {
    
    let navigationController: UINavigationController?
    
    var items: [UIBarButtonItem] {
        get { return createBarButtons() }
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        navigationController?.toolbar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
        
    private func createBarButtons() -> [UIBarButtonItem] {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let notes = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(presentNote))
        let pics = UIBarButtonItem(title: "Pictures", style: .plain, target: self, action: #selector(presentPictures))
        let vids = UIBarButtonItem(title: "Videos", style: .plain, target: self, action: #selector(presentVideos))
        for button in [notes, pics, vids] {
            setupTheme(for: button)
        }
        return [notes, flexibleSpace, pics, flexibleSpace, vids]
    }
    
    func setupTheme(for button: UIBarButtonItem) {
        button.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
    }
}
private extension ToolbarItems {

    enum VCType {
        case notes, pictures, videos
    }

    func viewControllerFrom(type: VCType) -> UIViewController & StandardViewControllerProtocol {
        switch type {
        case .notes:
            return NotesUIViewController()
        case .pictures:
            return PicturesUIViewController()
        case .videos:
            return VideosUIViewController()
        }
    }
    
    func present(type: VCType) {
        let newVC = viewControllerFrom(type: type)
        
        if let oldVC = navigationController?.topViewController as? StandardViewControllerProtocol {
            newVC.currentGoal = oldVC.currentGoal
            navigationController?.popViewController(animated: false)
            navigationController?.pushViewController(newVC, animated: false)
        }
    }
    
    
    @objc func presentNote() {
        if navigationController?.topViewController is NotesUIViewController {
            return
        }
        
        present(type: .notes)
    }
    
    @objc func presentPictures() {
        if navigationController?.topViewController is PicturesUIViewController {
            return
        }
        present(type: .pictures)
    }
    
    @objc func presentVideos() {
        if navigationController?.topViewController is VideosUIViewController {
            return
        }
        present(type: .videos)
    }
}
