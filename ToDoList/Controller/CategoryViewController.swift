//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

class CategoryViewController: MainViewController {
    
    // MARK: - Properties
    
    var categories = [Category]()
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CellId")
        updateDataSource()
        navigationItem.title = "CATEGORIES"
        tableView.sectionHeaderTopPadding = 10
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // Two methods below help with the spacing between the cells
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? CategoryCell else {
            fatalError("Unable to dequeue the CustomCell")
        }
        cell.baseCellDelegate = self
        let quantity = categories[indexPath.section].quantity
        let quantityDone = categories[indexPath.section].quantityDone
        cell.textField.text = categories[indexPath.section].name
        cell.quantityLabel.text = "\(quantityDone) / \(quantity)"
        let progress = Float(quantityDone) / Float(quantity)
        if quantityDone == 0 && quantity == 0 {
            cell.progressView.progress = 0
        } else {
            cell.progressView.progress = progress
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.section]
        /// passing coreDataStack here
        let vc = ToDoListViewController(coreDataStack: coreDataStack)
        vc.title = category.name
        vc.selectedCategory = category
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - UIInteraction
    
    @objc override func sortButtonTapped() {
        if categories.count > 1 {
            categories.sort{$0.name! < $1.name!}
            tableView.reloadData()
        }
    }
    
    @objc override func addButtonTapped() {
        let ac = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
        ac.addAction(UIAlertAction(title: "Add ", style: .default, handler: { [weak self, weak ac] _ in
            guard let newCategory = ac?.textFields?[0].text else { return }
            let trimmedCategory = newCategory.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.addCategory(trimmedCategory)
        }))
    }
    
    //MARK: - Helpers
    
    func addCategory(_ category: String) {
        if categoryAlreadyExists(category) || category == "" {
            return
        } else {
            let newCategory = coreDataStack.addObject(entityType: Category.self)
            categories.append(newCategory)
            newCategory.name = category
            coreDataStack.saveObject()
            tableView.reloadData()
        }
    }
    
    func categoryAlreadyExists(_ category: String) -> Bool {
        if categories.contains(where: { $0.name == category}) {
            let alert = UIAlertController(title: "The category already exists", message: "Please enter unique category name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            tableView.reloadData()
            return true
        } else {
            return false
        }
    }
    
    override func setupViews() {
        super.setupViews()
//        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: -8))
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }

    // MARK: - CoreData
    
    func updateDataSource() {
        self.coreDataStack.fetchObjects(entityName: Category.self, predicate: nil) { (fetchResult) in
            switch fetchResult {
            case .success(let categories):
                self.categories = categories
            case .failure(_):
                self.categories.removeAll()
            }
            self.tableView.reloadData()
        }
    }
    
    override func remove(at indexPath: IndexPath) {
        super.remove(at: indexPath)
        let category = categories[indexPath.section]
        coreDataStack.deleteObject(category)
        self.categories.remove(at: indexPath.section)
        tableView.reloadData()
        coreDataStack.saveObject()
    }
}

    // MARK: - BaseCellDelegate

extension CategoryViewController: BaseCellDelegate {
    func updateWithTitle(_ sender: BaseCell, title: String) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            navigationItem.rightBarButtonItems = []
            guard let categoryName = categories[selectedIndexPath.section].name else { return }
            if categoryName == title {
                return
            } else if categoryAlreadyExists(title) {
                return
            } else {
                categories[selectedIndexPath.section].name = title
                coreDataStack.saveObject()
            }
        }
    }
}










