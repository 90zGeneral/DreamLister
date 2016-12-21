//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/20/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    //Call this function when Item is inserted into NSManagedObject Context
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        //Set the created property to NSDate()
        self.created = NSDate()
    }
    
}
