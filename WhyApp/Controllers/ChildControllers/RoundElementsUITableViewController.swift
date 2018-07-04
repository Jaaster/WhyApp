//
//  RoundElementsUITableViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/1/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class RoundElementsUITableViewController<T: XCoreDataProtocol>: UITableViewController {

    required init(elements: [T], goal: Goal?, swipeButtons: (delete: String?, edit: String?)) {
        super.init(style: UITableViewStyle.plain)
        self.elements = elements
        self.goal = goal
        self.swipeButtons = swipeButtons
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rowHeight: CGFloat = 75
    var goal: Goal?
    var elements: [T]!
    var swipeButtons: (delete: String?, edit: String?)
//    var userPromptMessage: String {
//        guard let elementType = elementType else {
//            return ""
//        }
//
//        switch elementType {
//        case .notes:
//            return "Write the WHY"
//        case .videos:
//            return "Record the WHY"
//        case .goals:
//            return "Time to start your journey"
//        }
//    }
//
    var userShouldBePrompted: Bool {
        return elements.count < 1
    }
    
    var cellSelectedDelegate: RoundElementsUITableViewControllerDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        guard let parentVC = parent else {
            return
        }
        
//        if userShouldBePrompted {
//            parentVC.promptUser(with: userPromptMessage)
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section >= elements.count {
            return cell
        }
        cell.textLabel?.text = elements[indexPath.section].data
        cell.backgroundColor = .fadedBlack
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        if T.self is Video.Type {
            let imageView = imageViewFromVideo(index: indexPath.section)
            cell.addSubview(imageView)
            setupConstraints(for: imageView, in: cell)
            imageView.contentMode = .scaleAspectFill
            return cell
        }
        return cell
    }
    
    func setupConstraints(parentView: UIView, spacing: CGFloat, button: UIView) {
        view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: spacing).isActive = true
        view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -spacing).isActive = true
        view.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -spacing).isActive = true
    }
    
    private func setupConstraints(for imageView: UIImageView, in cell: UITableViewCell) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
    }
    
    func imageViewFromVideo(index: Int) -> UIImageView {
        let imageView = UIImageView()
        guard let video = elements[index] as? Video else {
            return imageView
        }
        
        imageView.image = video.thumbNailImage()
        return imageView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return elements.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectedDelegate?.select(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()

        if let deleteButtonTitle = swipeButtons.delete {
            let delete = UIContextualAction(style: .destructive, title: deleteButtonTitle) { (action, sourceView, completionHandler) in
                self.cellSelectedDelegate?.delete(at: indexPath)
                completionHandler(true)
            }
            actions.append(delete)
        }
        if let editButtonTitle = swipeButtons.edit {
            let edit = UIContextualAction(style: .normal, title: editButtonTitle) { (action, sourceView, completionHandler) in
                self.cellSelectedDelegate?.edit(at: indexPath)
                completionHandler(true)
            }
            actions.append(edit)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: actions)
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}

protocol RoundElementsUITableViewControllerDelegate {
    func select(at indexPath: IndexPath)
    func delete(at indexPath: IndexPath)
    func edit(at indexPath: IndexPath)
}

extension RoundElementsUITableViewControllerDelegate {
    func edit(at indexPath: IndexPath) {}
    func select(at indexPath: IndexPath) {}
    func delete(at indexPath: IndexPath) {}
}
