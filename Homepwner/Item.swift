//
//  Copyright © 2015 Big Nerd Ranch
//

import Foundation
import UIKit

class Item: NSObject, NSCoding
{
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dataCreated")
        aCoder.encode( itemKey, forKey: "itemKey")
        aCoder.encode( serialNumber, forKey: "serialNumber")
        
        aCoder.encode( valueInDollars, forKey: "valueInDollars")
    }
    
    required init( coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject( forKey: "name") as! String
        dateCreated = aDecoder.decodeObject( forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject( forKey: "itemKey") as! String
        serialNumber = aDecoder.decodeObject( forKey: "serialNumber") as! String?
        
        valueInDollars = aDecoder.decodeInteger( forKey: "valueInDollars")
        
        super.init()
    }
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    let itemKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
    }
   
    convenience init(create: Bool = false)
    {
        if create {
            
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
        else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}
