//
//  NotesUIViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/1/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//


import UIKit
import CoreData
class NotesUIViewController: UIViewController, StandardViewControllerProtocol {
    
    var shouldPromptUser: Bool {
        return notes.count < 1
    }
    
    var currentGoal: Goal!
    var currentNote: Note?
    var toolbarItemsObject: ToolbarItems?
    
    var notes: [Note] {
        return currentGoal.relationalObjects(type: Note())
    }
    
    lazy var roundElementVC: RoundElementsUITableViewController<Note> = {
        let roundElementVC = RoundElementsUITableViewController(elements: notes, goal: currentGoal, swipeButtons: (delete: "Delete", edit: "Edit"))
        return roundElementVC
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.becomeFirstResponder()
        textView.keyboardAppearance = .dark
        return textView
    }()
    
    private let addElementUIButton = UIAddElementButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        setDelegates()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let transitionCoordinator = transitionCoordinator {
            viewWillTransition(to: view.bounds.size, with: transitionCoordinator)
        }
        setupToolbar()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldPromptUser {
            promptUser(with: "Write the WHY")
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
}

private extension NotesUIViewController {
    
    func setDelegates() {
        roundElementVC.cellSelectedDelegate = self
        addElementUIButton.delegate = self
        textView.delegate = self

    }
    
    func setupToolbar() {
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        toolbarItemsObject = ToolbarItems.init(navigationController: navigationController)
        toolbarItems = toolbarItemsObject?.items
    }
    
    func setupViews() {
        view = UIGradientView(frame: view.frame)
        addChildViewController(roundElementVC)
        addSubViews()
        setupConstraints()
    }
    
    func addSubViews() {
        view.addSubview(addElementUIButton)
        view.addSubview(roundElementVC.view)
    }
    
    func setupConstraints() {
        let spacing = CGFloat(15)
        roundElementVC.setupConstraints(parentView: view, spacing: spacing, button: addElementUIButton)
        addElementUIButton.setupConstraints(view: view, spacing: spacing)
    }
}

extension NotesUIViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let increase = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(increaseFontSize))
        let decrease = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(decreaseFontSize))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        space.customView?.translatesAutoresizingMaskIntoConstraints = false
        done.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        for button in [increase, decrease, done] {
            button.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        }
        
        toolbar.setItems([decrease, increase, space, done], animated: true)
        
        textView.inputAccessoryView = toolbar
        return true
    }
    
    @objc func increaseFontSize() {
        textView.font = textView.font?.withSize((textView.font?.pointSize)! + 1)
    }
    
    @objc func decreaseFontSize() {
        textView.font = textView.font?.withSize((textView.font?.pointSize)! - 1)
    }
}

extension NotesUIViewController: EditWhyDeleteButtonDelegate {
    @objc func delete() {
        if let currentNote = currentNote {
            currentGoal.removeFromNotes(currentNote)
            CDPersistenceService.context.delete(currentNote)
            CDPersistenceService.saveContext()
        }
        
        reloadValues()
        reloadUI()
        navigationController?.popViewController(animated: true)
    }
}

extension NotesUIViewController: RoundElementsUITableViewControllerDelegate {
    
    func edit(at indexPath: IndexPath) {
        let editWhyVC = EditWhyViewController()
        textView.text = roundElementVC.tableView.cellForRow(at: indexPath)?.textLabel?.text
        textView.translatesAutoresizingMaskIntoConstraints = false
        editWhyVC.editorView = textView
        editWhyVC.setupSubViews()
        editWhyVC.deleteButtonDelegate = self
        currentNote = notes[indexPath.section]
        navigationController?.pushViewController(editWhyVC, animated: true)
    }
    
    func delete(at indexPath: IndexPath) {
        let selectedNote = notes[indexPath.section]
        currentGoal?.removeFromNotes(selectedNote)
        CDPersistenceService.context.delete(selectedNote)
        CDPersistenceService.saveContext()
        reloadValues()
        reloadUI()
    }
    
    func select(at indexPath: IndexPath) {
        edit(at: indexPath)
    }
}

extension NotesUIViewController: AddElementUIButtonDelegate {
    
    func addElement() {
        let editWhyVC = EditWhyViewController()
        editWhyVC.editorView = textView
        editWhyVC.setupSubViews()
        editWhyVC.deleteButtonDelegate = self
        present(editWhyVC, animated: true, completion: nil)
    }
    
   @objc func doneButton() {
        if let currentNote = currentNote {
            currentNote.data = textView.text
            navigationController?.popViewController(animated: true)
        } else {
            let note = Note(context: CDPersistenceService.context)
            note.data = textView.text
            currentGoal.addToNotes(note)
            dismiss(animated: true, completion: nil)
        }
    
        CDPersistenceService.saveContext()
        reloadValues()
        reloadUI()
    }
}

private extension NotesUIViewController {
    func reloadValues() {
        currentNote = nil
        textView.text = ""
        roundElementVC.elements = notes
    }

    func reloadUI() {
        roundElementVC.tableView.reloadData()
    }
}
