//
//  ItemCell.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/21/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
    ////The main configure cell method to update the tableViewCells
    func mainConfigureCell(item: Item) {
        
        ////Set the outlets to the properties of the Item Entity
        itemName.text = item.title
        itemPrice.text = "$\(item.price)"
        itemDescription.text = item.details
        
    }
    

}
