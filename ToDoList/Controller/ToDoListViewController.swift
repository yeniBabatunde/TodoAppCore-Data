//
//  ViewController.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

class ToDoListViewController: MainViewController {
  
    // MARK: - Properties
    
    var items = [Item]()
    var selectedCategory: Category? {
        didSet {
            updateDataSource()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItemCell.self, forCellReuseIdentifier: "CellId")
        shouldShowRemoveAllButton()
    }
    
    // MARK: - TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? ItemCell else { fatalError("Unable to dequeue ItemCell")}
        cell.baseCellDelegate = self
        cell.itemCellDelegate = self
        let item = items[indexPath.row]
        cell.textField.text = item.title
        cell.checkmarkButton.isSelected = item.isDone
        cell.textField.textColor = item.isDone ? .label.withAlphaComponent(0.5) : .label.withAlphaComponent(1)
        return cell
    }
    
    // MARK: - UIInteraction
    
    @objc override func sortButtonTapped() {
        if items.count > 1 {
            items.sort{$0.title! < $1.title!}
            tableView.reloadData()
        }
    }

    @objc func removeAllButtonTapped() {
        let alert = UIAlertController(title: "Are you sure you want to remove all items?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Delete all", style: .default) { [weak self] _ in
            self?.removeAllItems()
            self?.navigationItem.setRightBarButton(nil, animated: true)
        })
    }
    
    @objc override func addButtonTapped() {
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add Item", style: .default) { [weak self, weak alert] _ in
            guard let item = alert?.textFields?[0].text else { return }
            let trimmedItem = item.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.addItem(trimmedItem)
        })
        present(alert, animated: true)
    }
    //MARK: - ViewSetup
    
    override func setupViews() {
        super.setupViews()
        tableView.anchorSize(to: view)
    }
    
    
    func shouldShowRemoveAllButton() {
        if items.isEmpty { return }
        // checks, if all items in the array have been selected
        if items.allSatisfy({ $0.isDone == true }) {
            let image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
            let binButton = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .plain, target: self, action: #selector(removeAllButtonTapped))
            navigationItem.rightBarButtonItems = [binButton]
        } else {
            navigationItem.rightBarButtonItems = []
        }
    }
    
    
    // MARK: - CoreData
    
    func addItem(_ item: String) {
        if item == "" { return }
        let newItem = coreDataStack.addObject(entityType: Item.self)
        
        newItem.title = item
        newItem.isDone = false
        selectedCategory?.quantity += 1
        newItem.parentCategory = self.selectedCategory
        items.append(newItem)
        shouldShowRemoveAllButton()
        tableView.reloadData()
        coreDataStack.saveObject()
    }
    
    func updateDataSource() {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        self.coreDataStack.fetchObjects(entityName: Item.self, predicate: predicate) { (fetchResult) in
            switch fetchResult {
            case .success(let items):
                self.items = items
            case .failure(_):
                self.items.removeAll()
            }
            self.tableView.reloadData()
        }
    }
    
    override func remove(at indexPath: IndexPath) {
        super.remove(at: indexPath)
        let item = items[indexPath.row]
        coreDataStack.deleteObject(item)
        if item.isDone {
            selectedCategory?.quantityDone -= 1
        }
        self.selectedCategory?.quantity -= 1
        self.items.remove(at: indexPath.row)
        shouldShowRemoveAllButton()
        tableView.reloadData()
        coreDataStack.saveObject()
    }
    
    private func removeAllItems() {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        coreDataStack.deleteAllObjects(entityName: Item.self, predicate: predicate)
        items.removeAll()
        selectedCategory?.quantity = 0
        selectedCategory?.quantityDone = 0
        tableView.reloadData()
        coreDataStack.saveObject()
    }
}
// MARK: - ItemCellProtocol

extension ToDoListViewController: ItemCellDelegate {
    func toggleIsDone(sender: ItemCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            let item = items[selectedIndexPath.row]
            item.isDone.toggle()
            if item.isDone {
                selectedCategory?.quantityDone += 1
            } else {
                selectedCategory?.quantityDone -= 1
            }
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            shouldShowRemoveAllButton()
            coreDataStack.saveObject()
        }
    }
}

// MARK: - BaseCellProtocol

extension ToDoListViewController: BaseCellDelegate {
    func updateWithTitle(_ sender: BaseCell, title: String) {
        if let selectedIndexPath = selectedIndexPath {
            items[selectedIndexPath.row].title = title
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
        navigationItem.rightBarButtonItems = []
        coreDataStack.saveObject()
        shouldShowRemoveAllButton()
    }
}
