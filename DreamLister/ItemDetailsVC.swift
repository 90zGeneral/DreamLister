//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/25/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var itemImage: UIImageView!
    
    
    //Array of all the stores
    var stores = [Store]()
    
    //Item to be edited
    var itemToEdit: Item?
    
    //
    var imagePicker: UIImagePickerController!
    
    //How many columns in the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //How many rows in a pickerView column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    //The title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    //Which row was selected by the user
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Make updates
        
    }
    
    //Fetch the newly created stores
    func getStores() {
        let fetchReq: NSFetchRequest<Store> = Store.fetchRequest()
        
        //Sort store names for pickerView in alphabetical order
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchReq.sortDescriptors = [nameSort]
        
        //Perform the fetch and put each instance of Store in the stores array
        do {
            self.stores = try context.fetch(fetchReq)
            
            //Reload all components in the storePicker
            self.storePicker.reloadAllComponents()
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //Create new instances of the Store Entity
    func testStores() {
//        let store1 = Store(context: context)
//        store1.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Walmart"
//        let store3 = Store(context: context)
//        store3.name = "Apple"
//        let store4 = Store(context: context)
//        store4.name = "BMW Dealership"
//        let store5 = Store(context: context)
//        store5.name = "Boeing"
//        let store6 = Store(context: context)
//        store6.name = "Island Shopping"
//        let store7 = Store(context: context)
//        store7.name = "NYC Realtors"
//        
//        //Save the new stores in CoreData
//        ad.saveContext()
        
    }
    
    //To edit an exisiting Item
    func loadItemData() {
        
        if let item = itemToEdit {
            
            //Assign the stored values to the textFields
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            //Assign the item image to the imageView
            itemImage.image = item.toImage?.image as? UIImage
            
            //To set the pickerView value to the item's pre-existing store
            if let store = item.toStore {
                var index = 0
                
                //Loop thru each Store in the stores array
                repeat {
            
                    //Create a store variable and check for a match with the item's store
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        //Exit the loop if the store is found before the condition turns false
                        break
                    }
                    
                    //Increment the index each time the stores does not match
                    index += 1
                
                //Condition for running the loop
                }while (index < stores.count)
            }
        }
    }
    
    //Save item
    @IBAction func saveItem(_ sender: UIButton) {
        
        //Prevents the user from leaving any of the textFields blank
        if titleField.text != "" && priceField.text != "" && detailsField.text != "" {
            
            //Its value depends on the value of itemToEdit
            var newItem: Item!
            
            //Create a new instance of Image and set its image value to the itemImage value
            let picture = Image(context: context)
            picture.image = itemImage.image
            
            if itemToEdit == nil {
                
                //Create a new item
                newItem = Item(context: context)
                
            }else {
                
                //Assign itemToEdit's value to newItem
                newItem = itemToEdit
            }
            
            //Assign the newItem Entity to the picture Entity
            newItem.toImage = picture
            
            //Set newItem's title, price, and details to the values entered in the textFields
            if let userTitle = titleField.text {
                newItem.title = userTitle
            }
            if let userPrice = priceField.text {
                newItem.price = Double(userPrice)!
            }
            if let userDetails = detailsField.text {
                newItem.details = userDetails
            }
            
            //Assign the selected store to the newly created store
            newItem.toStore = stores[storePicker.selectedRow(inComponent: 0)]
            
            //Save the new store to CoreData
            ad.saveContext()
            
            //Segue back to the MainVC
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    //To delete an existing item
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        //Return to the MainVC
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Add a new image to an item
    @IBAction func addImage(_ sender: UIButton) {
        
        //Present the image picker controller
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Extracting the image and assigning it to the outlet
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            itemImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //To remove the navigation bar button title "DreamLister" when the ItemDetailsVC loads
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        //Set the delegates
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //Instantite the imagePicker and set the delegate
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Call functions
        testStores()
        getStores()
        
        
        /* Had to move this conditional statement out of the testScores method bcuz loadItemData can't be called b4 getStores since getStores will populate the stores array. */
        if itemToEdit != nil {
            loadItemData()
        }
        
    }

}
