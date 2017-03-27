//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
 
    @IBAction func addNewItem(_ sender: UIBarButtonItem)
    {
        // Create a new Item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table.
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // Added From Book
    override func prepare(for seque: UIStoryboardSegue, sender: Any?)
    {
        // If the triggered segue is the "showItem" segue
        switch seque.identifier
        {
            case "showItem"?:
                // Figure out which row was just tapped
                if let row = tableView.indexPathForSelectedRow?.row
                {
                    // Get the item associated with this row and pass it along
                    let item = itemStore.allItems[row]
                    let detailViewController = seque.destination as! DetailViewController
                    detailViewController.item = item
                }
            default:
                preconditionFailure("Unexpected segue identifier.")
        }
    }

    // Added From Book
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // The overall View of the controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Adds the background image to the view
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)
        tableView.backgroundView?.contentMode = .scaleAspectFit // Fits it to the screen correctly
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    // This function prevents the Cell from moving between sections
    // UITableView Delegate Method to propose a new spot if the new location is not where we want it to be
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    {
        if sourceIndexPath.section != proposedDestinationIndexPath.section
        {
            var row = 0
            
            // If the new destination is a different section than the one it is in
            if sourceIndexPath.section < proposedDestinationIndexPath.section
            {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section) // Redirect path
        }
        return proposedDestinationIndexPath
    }
    
    // This function moves the cells between each other
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath)
    {
            // Update the model
            itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // Renames the delete button to "Remove" instead
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    // Function for deleting items from the list
    // Will confirm with the user if they want to delete the item they chose
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath)
    {
            // If the table view is asking to commit a delete command...
            if editingStyle == .delete {
                // Changed to .section instead of .row to delete from that particular section instead it is coming from
                let item = itemStore.allItems[indexPath.section]
                
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title,
                    message: message,
                    preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                    handler: { (action) -> Void in
                        // Remove the item from the store
                        self.itemStore.removeItem(item)
                        
                        // Also remove that row from the table view with an animation
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
                ac.addAction(deleteAction)
                
                // Present the alert controller
                present(ac, animated: true, completion: nil)
            }
    }
    
    // Adds rows only to the first section. Section 0
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount = 0
        if section == 0
        {
            rowCount = itemStore.allItems.count
        }
        
        return rowCount
    }
    
    // Creates 2 sections in the list without creating a struct. Section 1 is to seem like it is part of 
    // the Items list
    //----------------------------------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    // Names the Sections respective of their number values
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Items"
        }
        else
        {
            return "No more Items!"
        }
    }
    
    // Function that generates the appearance of the cells
    //----------------------------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
            for: indexPath) as! ItemCell
            
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        // Cell Formatting
        cell.nameLabel.text = item.name
        cell.nameLabel.textColor = UIColor.blue
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        cell.backgroundColor = .clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        // Changes the Color of the Number values to red if it is above $50 and to gree if it is lower than $50
        if item.valueInDollars > 50
        {
            cell.valueLabel.textColor = UIColor.red
        }
        else
        {
            cell.valueLabel.textColor = UIColor.green
        }
            
            return cell
    }
}
