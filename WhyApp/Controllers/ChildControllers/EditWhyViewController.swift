//
//  EditWhyViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/27/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

protocol EditWhyDeleteButtonDelegate {
    func delete()
}

class EditWhyViewController: UIViewController {
    
    var editorView: UIView?
    var deleteButtonDelegate: EditWhyDeleteButtonDelegate?
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        addSubViews()
        constrainSubViews()
    }
}
private extension EditWhyViewController {
   
    func constrainSubViews() {
        editorView?.translatesAutoresizingMaskIntoConstraints = false
        editorView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        editorView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        editorView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        editorView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func addSubViews() {
        if let editorView = editorView {
            view.addSubview(editorView)
        }
    }
    
    @objc func deleteButtonPressed() {
        deleteButtonDelegate?.delete()
    }
}
