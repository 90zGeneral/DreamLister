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
    
    //The main configure cell method to update the tableViewCells
    func mainConfigureCell(item: Item) {
        
        //Set the outlets to the properties of the Item Entity
        itemName.text = item.title
        itemPrice.text = "$\(Int(item.price))"
        itemDescription.text = item.details
        
        //Set the default image for each cell whose item does not have an existing image
        if item.toImage == nil {
            itemImage.image = UIImage(named: "gulfstreamG650")
        }else {
            itemImage.image = item.toImage?.image as? UIImage
        }
        
    }
    

}
