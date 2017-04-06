//
//  datePickerViewController.swift
//  Homepwner
//
//  Created by Connor Gordon on 4/5/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class datePickerViewController: UIViewController, UINavigationControllerDelegate
{
    var item: Item!
    {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidLoad()
        print("Item = ", item.dateCreated) // Tells me what the date
    }
    
    // Saves the Date chosen when page is sent back to previous view
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
    
}
