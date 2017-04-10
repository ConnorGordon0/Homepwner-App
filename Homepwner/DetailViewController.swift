//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Connor Gordon on 3/26/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    
    var item: Item!
    {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    var itemStore: ItemStore!

    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        print("ItemStore in detail = ",itemStore)
        //itemStore.removeItem(item)
        //performSegue(withIdentifier: "cancelItem", sender: cancel)
        navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    // Performs the Segue into the dateChange viewController.
    //---------------------------------------------------------------------------------------------------------------
    @IBAction func changeDate(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "showDate", sender: changeDate)
    }
    
    // Passes the Date data to the next view controller to be changed
    //---------------------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDate"
        {
            let toViewController = segue.destination as! datePickerViewController
            toViewController.item = item
        }
    }
    
    // Delete a photo from the object
    //---------------------------------------------------------------------------------------------------------------
    @IBAction func deletePhoto(_ sender: UIBarButtonItem)
    {
        imageView.image = nil
    }
    
    //---------------------------------------------------------------------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------------------------
    @IBAction func takePicture(_ sender: UIBarButtonItem)
    {
        let imagePicker = UIImagePickerController()
        
        // If the device camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
            
            // Camera Overlay
            let customViewController = CustomOverlayViewController(nibName: "CustomOverlayViewController", bundle: nil)
            let customView:CustomOverlayview = customViewController.view as! CustomOverlayview
            customView.frame = imagePicker.view.frame
            present(imagePicker, animated: true, completion: {imagePicker.cameraOverlayView = customView})
            
            print("Using on board Camera")
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
            print("Using Photo Library")
        }
        
        imagePicker.delegate = self
        
        // Place Image picker on the Screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------------------------
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    //---------------------------------------------------------------------------------------------------------------
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    //---------------------------------------------------------------------------------------------------------------
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    //---------------------------------------------------------------------------------------------------------------
    func textFieldShouldReturn(_ textClass: UITextField) -> Bool
    {
            textClass.resignFirstResponder()
            return true
    }
    
    // Clears the Text Field when called
    //---------------------------------------------------------------------------------------------------------------
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.text = ""
    }
    
    //---------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        nameField.text         = item.name
        serialNumberField.text = item.serialNumber
        
        // If Else Statement to clear the value and date fields on new items
        if (item.valueInDollars != 0) || item.dateCreated != nil
        {
            valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
            dateLabel.text  = dateFormatter.string(from: item.dateCreated!)
            
            if nameField.text == "" || valueField.text == ""
            {
                navigationController?.isNavigationBarHidden = true
            }
            else
            {
                navigationController?.isNavigationBarHidden = false
            }
            
            print("Value Field has a value")
        }
        else
        {
            print("value Field has no value")
            textFieldDidBeginEditing(valueField)
            dateLabel.text = ""
            navigationController?.isNavigationBarHidden = true
        }
        
        // get the item Key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    //---------------------------------------------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)

        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText)
        {
            item.valueInDollars = value.intValue
        }
        else
        {
            item.valueInDollars = 0
        }
    }
}

//---------------------------------------------------------------------------------------------------------------
class textClass: UITextField, UITextFieldDelegate
{
    //---------------------------------------------------------------------------------------------------------------
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        delegate = self
    }
    
    //---------------------------------------------------------------------------------------------------------------
    override func becomeFirstResponder() -> Bool
    {
        super.becomeFirstResponder()
        self.borderStyle = UITextBorderStyle.line
        
        print("Changes to Line")
        
        return true
    }
    
    //---------------------------------------------------------------------------------------------------------------
    override func resignFirstResponder() -> Bool
    {
        super.resignFirstResponder()
        self.borderStyle = UITextBorderStyle.roundedRect
        print("Changes back to rounded Rect")
        
        return true
    }
}

