//
//  fieldStyle.swift
//  Homepwner
//
//  Created by Connor Gordon on 3/28/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Foundation

class fieldStyle: UITextField
{
    override func becomeFirstResponder() -> Bool
    {
        self.borderStyle = UITextBorderStyle.line
        return true
    }

    override func resignFirstResponder() -> Bool
    {
        self.borderStyle = UITextBorderStyle.roundedRect
        return true
    }
}
