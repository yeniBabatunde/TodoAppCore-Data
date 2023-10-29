//
//  MainViewController.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var coreDataStack: CoreDataStack
    var selectedIndexPath: IndexPath?
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .viewBackground
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        notificationForKeyboard()
    }
 
    // MARK: - UIComponents
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .viewBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var roundedButton: RoundedButton = {
        let button = RoundedButton()
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Helpers

    func notificationForKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height , right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // reset back the content inset to zero after keyboard is gone
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UIInteraction
    
    @objc func addButtonTapped() {
    }
    @objc func sortButtonTapped() {
    }
    
    @objc func doneButtonTapped() {
        if let selectedIndexPath = selectedIndexPath {
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? BaseCell {
                cell.textField.isUserInteractionEnabled = false
                cell.textField.endEditing(true)
            }
        }
    }
    
    func setupNavigationController() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .label
        let image = UIImage(systemName: "arrow.up.arrow.down.circle")?.withRenderingMode(.alwaysTemplate)
        let sortButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = sortButton
    }
    
    //MARK: - ViewSetup
    
    public func setupViews() {
        view.addSubview(tableView)
        view.addSubview(roundedButton)
        roundedButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        roundedButton.widthAnchor.constraint(equalTo: roundedButton.heightAnchor).isActive = true
        roundedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        roundedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
    }
    
    // MARK: - CoreData
    
    func remove(at indexPath: IndexPath) {
        if navigationItem.rightBarButtonItems != nil {
            navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    func rename(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BaseCell {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cell.textField.isUserInteractionEnabled = true
                    cell.textField.becomeFirstResponder()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
                }
        }
        tableView.isEditing = false
        selectedIndexPath = indexPath
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate Methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? BaseCell else {
            fatalError("Unable to dequeue the cell as BaseCell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            self.remove(at: indexPath)
            Haptics.playSuccessNotification()
        }
        let rename = UIContextualAction(style: .normal, title: "Edit") { action, view, handler in
            self.rename(at: indexPath)
        }
        rename.backgroundColor = .lightGray
        if tableView.isEditing == false {
            return UISwipeActionsConfiguration(actions: [delete, rename])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
}


