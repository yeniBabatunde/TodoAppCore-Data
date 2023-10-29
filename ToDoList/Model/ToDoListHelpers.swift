//
//  ToDoListHelpers.swift
//  ToDoList
//
//  Created by Szymon Tadrzak on 31/03/2022.
//

import UIKit

struct ToDoListHelpers {
    
     var coreDataStack: CoreDataStack
    
    var items = [Item]()

    func getTitle(_ row: Int) -> String? {
        return items[row].title
    }
    
    func getColor(for row: Int) -> UIColor {
        if items[row].done {
            return .label.withAlphaComponent(0.5)
        } else {
            return .label.withAlphaComponent(1)
        }        
    }
    
    mutating func sortItems() {
        if items.count > 1 {
            items.sort{$0.title! < $1.title!}
        }
    }
    
    func shouldShowBinButton() -> UIBarButtonItem? {
        if items.isEmpty { return nil }
        // checks, if all items in the array have been selected
        if items.allSatisfy({ $0.done == true }) {
            let image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
            let binButton = UIBarButtonItem(image: image)
            return binButton
//            navigationItem.rightBarButtonItems = [binButton]
        } else {
//            navigationItem.rightBarButtonItems = []
            return nil
        }
    }
    
    mutating func removeAll(predicate: NSPredicate) {
        coreDataStack.deleteAllObjects(entityName: Item.self, predicate: predicate)
        items.removeAll()
        coreDataStack.saveObject()
    }
    
    mutating func addItem(_ item: String, completion: () -> Void) -> Item? {
        if item == "" { return nil }
        let newItem = coreDataStack.addObject(entityType: Item.self)
        newItem.title = item
        newItem.done = false
//        selectedCategory?.quantity += 1
//        newItem.parentCategory = self.selectedCategory
        completion()
        
        items.append(newItem)
        coreDataStack.saveObject()
        return newItem
    }
    

}

