//
//  Copyright © 2015 Big Nerd Ranch
//

import Foundation
import UIKit

class ItemStore
{
    
    var allItems: [Item] = []
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init()
    {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item]
        {
            allItems = archivedItems
        }
    }
    
    func saveChanges() -> Bool
    {
        print("Saving items to: \(itemArchiveURL.path)")
        
        // Method takes care of saving every single item in allItems to the itemArchiveURL
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int)
    {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can re-insert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
  
    @discardableResult func createItem() -> Item
    {
        let newItem = Item(name: "", serialNumber: "", valueInDollars: 0)
        
        allItems.append(newItem)
        
        print("New Item = ",newItem)
        
        return newItem
    }
 
    func removeItem(_ item: Item)
    {
        if let index = allItems.index(of: item)
        {
            print("Item === ",item)
            allItems.remove(at: index)
        }
    }
    
}
