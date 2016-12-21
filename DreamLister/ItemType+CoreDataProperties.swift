//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/20/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
