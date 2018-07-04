//
//  MainViewController.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/1/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

class GoalsUIViewController: UIViewController {
    
    var shouldPromptUser: Bool {
        return goals.count < 1
    }
    private let addElementUIButton = UIAddElementButton()
    private var currentGoal: Goal?
    
    private lazy var tableViewController: RoundElementsUITableViewController<Goal> = {
        let vc = RoundElementsUITableViewController(elements: goals, goal: nil, swipeButtons: (delete: "Delete", edit: "Edit"))
        return vc
    }()
    
    private var goals: [Goal] {
        return CoreDataLists().goals()
    }
    
    private var isEditingGoal: Bool {
        return currentGoal != nil
    }
    
    private lazy var editorView: UIView = {
        let eView = UIView()
        eView.backgroundColor = .white
        return eView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Put your goal here"
        textField.returnKeyType = .done
        textField.keyboardAppearance = .dark
        textField.textAlignment = .center
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goals"
        setDelegates()
        addChildViewController(tableViewController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationControllerTheme()
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupViews()
        textField.becomeFirstResponder()
       
        if shouldPromptUser {
            promptUser(with: "You need more goals")
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

private extension GoalsUIViewController {

    func setDelegates() {
        addElementUIButton.delegate = self
        tableViewController.cellSelectedDelegate = self
        textField.delegate = self
    }

    func setupViews() {
        view = UIGradientView(frame: view.frame)
        addSubViews()
        setupConstraints()
        setupFrames()
    }
    
    func addSubViews() {
        view.addSubview(addElementUIButton)
        view.addSubview(tableViewController.view)
        editorView.addSubview(textField)
    }
    
    func setupConstraints() {
        let spacing = CGFloat(15)
        tableViewController.setupConstraints(parentView: view, spacing: spacing, button: addElementUIButton)
        addElementUIButton.setupConstraints(view: view, spacing: spacing)
    }
    
    func setupFrames() {
        if let tableView = tableViewController.tableView {
            let tableViewWidth = tableView.bounds.width
            textField.bounds = CGRect(x: 0, y: 0, width: tableViewWidth, height: 75)
            textField.center = tableView.center
        }
    }
    
    func setupNavigationControllerTheme() {
        navigationController?.navigationBar.barStyle = .black
    }
    
    func reloadValues() {
        textField.text = ""
        tableViewController.elements = goals
    }
    
    func reloadUI() {
        tableViewController.tableView.reloadData()
        
    }
}

extension GoalsUIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            doneButton()
            return true
        }
        return false
    }
}

extension GoalsUIViewController: AddElementUIButtonDelegate {
    func addElement() {
        let editWhyVC = EditWhyViewController()
        editWhyVC.editorView = editorView
        editWhyVC.setupSubViews()
        present(editWhyVC, animated: true)
    }
    
    func doneButton() {
        let goalTitle = textField.text
        
        if isEditingGoal {
            currentGoal?.data = goalTitle
        } else {
            let goal = Goal(context: CDPersistenceService.context)
            goal.data = goalTitle
        }
        
        CDPersistenceService.saveContext()
        reloadValues()
        reloadUI()
        dismiss(animated: true)
    }
}

extension GoalsUIViewController: RoundElementsUITableViewControllerDelegate {
    func select(at index: IndexPath) {
        let selectedGoal = goals[index.section]
        let vc = NotesUIViewController()
        vc.currentGoal = selectedGoal
        
        navigationController?.show(vc, sender: nil)
    }
    
    func edit(at index: IndexPath) {
        let selectedGoal = goals[index.section]
        currentGoal = selectedGoal
        textField.text = currentGoal?.data
        
        let editWhyVC = EditWhyViewController()
        editWhyVC.editorView = editorView
        editWhyVC.setupSubViews()
        present(editWhyVC, animated: true)
    }
   
    func delete(at index: IndexPath) {
        let selectedGoal = goals[index.section]
        CDPersistenceService.context.delete(selectedGoal)
        CDPersistenceService.saveContext()
        reloadValues()
    }
}
