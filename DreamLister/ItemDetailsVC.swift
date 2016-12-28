//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/25/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    //Array of all the stores
    var stores = [Store]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //To remove the navigation bar button title "DreamLister" when the ItemDetailsVC loads
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //Call function
        testStores()
        getStores()
        
    }

}
