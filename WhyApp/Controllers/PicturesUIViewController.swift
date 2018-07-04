//  PicturesUIViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/3/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class PicturesUIViewController: UIViewController, StandardViewControllerProtocol {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 75, height: 75)

        let cView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.backgroundColor = .clear
        
        return cView
    }()
    
    var images: [Image] {
        return currentGoal.relationalObjects(type: Image())
    }
    
    var currentGoal: Goal!
    var currentImage: Image?
   
    private var isEditingImage: Bool {
        get {
            return currentImage != nil
        }
    }
    
    var shouldPromptUser: Bool {
        return images.count < 1
    }
    
    private let addElementUIButton: UIAddElementButton = {
       return UIAddElementButton()
    }()
    
    var toolbarItemsObject: ToolbarItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItemsObject = ToolbarItems.init(navigationController: navigationController)
        toolbarItems = toolbarItemsObject?.items
        title = "Pictures"
        setupViews()
        collectionView.register(UIImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        addElementUIButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let transitionCoordinator = transitionCoordinator {
            viewWillTransition(to: view.bounds.size, with: transitionCoordinator)
        }
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldPromptUser {
            promptUser(with: "Capture the WHY")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            
        }) { (_) in
            self.view = UIGradientView(frame: self.view.frame)
            self.setupViews()
        }
    }
    
    
    
    func setupViews() {
        view = UIGradientView(frame: view.frame)
        addSubViews()
        constrainSubViews()
    }
    
    func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(addElementUIButton)
    }
    
    func constrainSubViews() {
        let spacing: CGFloat = 15
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: addElementUIButton.topAnchor, constant: -spacing).isActive = true
        
       addElementUIButton.setupConstraints(view: view, spacing: spacing)
    }
}

extension PicturesUIViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UIImageCollectionViewCell {
            cell.backgroundColor = .red
            cell.layer.cornerRadius = 15
            cell.clipsToBounds = true
            cell.imageView.image = images[indexPath.row].getUIImage()
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editWhyVC = EditWhyViewController()
        let imageView = UIImageView()
        let image = images[indexPath.row]
        currentImage = image
        imageView.image = image.getUIImage()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        editWhyVC.deleteButtonDelegate = self
        editWhyVC.editorView = imageView
        editWhyVC.setupSubViews()
        navigationController?.pushViewController(editWhyVC, animated: true)
    }
}

extension PicturesUIViewController: AddElementUIButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditWhyDeleteButtonDelegate {
   
    func delete() {
        if let currentImage = currentImage {
            currentGoal.removeFromImages(currentImage)
            CDPersistenceService.context.delete(currentImage)
            CDPersistenceService.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.navigationItem.title == "Photos" {
            viewController.navigationItem.title = "My Lame Photos XD"
        }
    }
    
    func addElement() {
        let imageLibraryViewController = UIImagePickerController()
        imageLibraryViewController.delegate = self
        imageLibraryViewController.sourceType = .photoLibrary
        present(imageLibraryViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerImageURL] as? URL {
            
            let image = Image(context: CDPersistenceService.context)
            image.data = url.lastPathComponent
            currentGoal.addToImages(image)
            CDPersistenceService.saveContext()
            
            collectionView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
}
