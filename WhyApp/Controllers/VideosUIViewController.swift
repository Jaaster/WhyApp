//
//  VideosUIViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/5/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
class VideosUIViewController: UIViewController, StandardViewControllerProtocol {
    var shouldPromptUser: Bool {
        return videos.count < 1
    }
    var toolbarItemsObject: ToolbarItems?
    var currentGoal: Goal!
    
    var videos: [Video] {
        return currentGoal.relationalObjects(type: Video())
    }
    
    lazy var roundElementVC: RoundElementsUITableViewController<Video> = {
        let roundElementVC = RoundElementsUITableViewController(elements: videos, goal: currentGoal, swipeButtons: (delete: "Delete", edit: nil))
        roundElementVC.rowHeight = tableViewRowHeight
        return roundElementVC
    }()
    
    private var tableViewRowHeight: CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return view.frame.height / 9
        }
        
        return 100

    }
    
    private let addElementUIButton: UIAddElementButton = {
        return UIAddElementButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        toolbarItemsObject = ToolbarItems.init(navigationController: navigationController)
        toolbarItems = toolbarItemsObject?.items
        
        title = "Videos"
        setupViews()
        roundElementVC.cellSelectedDelegate = self
        addElementUIButton.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let transitionCoordinator = transitionCoordinator {
            viewWillTransition(to: view.bounds.size, with: transitionCoordinator)
        }
        addChildViewController(roundElementVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldPromptUser {
            promptUser(with: "Record the WHY")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            
        }) { (_) in
            self.view = UIGradientView(frame: self.view.frame)
            self.setupViews()
            self.reloadData()
        }
    }
}

private extension VideosUIViewController {
    
    func setupViews() {
        view = UIGradientView(frame: view.frame)
        addSubViews()
        setupConstraints()
    }
    
    func addSubViews() {
        view.addSubview(roundElementVC.view)
        view.addSubview(addElementUIButton)
    }
    
    func setupConstraints() {
        
        let spacing: CGFloat = 15
        roundElementVC.setupConstraints(parentView: view, spacing: spacing, button: addElementUIButton)
        
        addElementUIButton.setupConstraints(view: view, spacing: spacing)
    }
    
    func playVideo(video: Video) {
        let avPlayer = video.avPlayer()
        let avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = avPlayer
        present(avPlayerViewController, animated: true, completion: nil)
    }
    
    func reloadData() {
        roundElementVC.elements = videos
        roundElementVC.rowHeight = tableViewRowHeight
    }
    
    func reloadUI() {
        roundElementVC.tableView.reloadData()
    }
}

extension VideosUIViewController: RoundElementsUITableViewControllerDelegate {
    func select(at indexPath: IndexPath) {
        playVideo(video: videos[indexPath.section])
    }

    func delete(at indexPath: IndexPath) {
        let selectedVideo = videos[indexPath.section]
        CDPersistenceService.context.delete(selectedVideo)
        currentGoal.removeFromVideos(selectedVideo)
        CDPersistenceService.saveContext()
        reloadData()
        reloadUI()
    }
}

extension VideosUIViewController: AddElementUIButtonDelegate {
    func addElement() {
        let videoPickerController = UIImagePickerController()
        videoPickerController.delegate = self
        videoPickerController.sourceType = .photoLibrary
        videoPickerController.mediaTypes = [kUTTypeMovie, kUTTypeImage] as [String]
        present(videoPickerController, animated: true, completion: nil)
    }
}

extension VideosUIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerMediaURL] as? URL {
            let video = Video(context: CDPersistenceService.context)
            video.data = url.lastPathComponent
            currentGoal.addToVideos(video)
            CDPersistenceService.saveContext()
            reloadData()
            reloadUI()
            dismiss(animated: true, completion: nil)
        }
    }
}
