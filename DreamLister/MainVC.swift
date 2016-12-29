//
//  MainVC.swift
//  DreamLister
//
//  Created by Roydon Jeffrey on 12/20/16.
//  Copyright © 2016 Italyte. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    //FRC works with Core Data and the TableView to efficiently collect the results from a fetchData request without loading all of it into memory at the sametime
    
    @IBOutlet var segmenter: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    //Declare FRC to operate on the Item Entity/Data Class
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //sections will be an [NSFetchedResultsSectionInfo] so just return its count
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //Grab the sections out of the fetchedResultsController
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        
        //Call the confireCell method and pass in the cell above
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    //A specific row to be selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Check if an array of Item exist and assign it to objs only if there is atleast 1 item in the array
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 {
            
            //Grab the selected Item in the objs array
            let selectedItem = objs[indexPath.row]
            
            //Segue to the ItemDetailsVC with the selectedItem
            performSegue(withIdentifier: "ItemDetails", sender: selectedItem)
        }
    }
    
    //Prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetails" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    //Configure a cell to be called in the cellForRowAt method
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        
        //Create an item to be passed into the mainConfigureCell method
        let item = fetchedResultsController.object(at: indexPath)
        cell.mainConfigureCell(item: item)
    }
    
    //Set a fixed height for each cell. This is the height from the prototype cell in storyboard
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //Fetch and Display the data
    func attemptFetch() {
        
        //Create a fetch request
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Sort the data being fetched by date then pass it into the fetchRequest
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        //Instantiate FRC
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //This controller must listen for the changes on the VC in order to update
        controller.delegate = self
        
        //Perform the fetching with the possibility of failing
        do {
            try controller.performFetch()
            
        }catch {
            let error = error as NSError
            print("\(error)")
        }
        
        //Assign controller to fetchedResultsController as its value
        fetchedResultsController = controller
        
    }
    
    //Listen for changes on the tableView and run this method before it does. Similar to tableView.reloadData()
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    //Run after changes are made
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //Handles modifications such as insert, move, delete, and update on the tableView
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        //type has 4 incorporated cases
        switch type {
        case .insert:
            if let selectedIndexPath = newIndexPath {
                tableView.insertRows(at: [selectedIndexPath], with: .fade)
            }
            break
        case .delete:
            if let selectedIndexPath = indexPath {
                tableView.deleteRows(at: [selectedIndexPath], with: .fade)
            }
            break
        case .update:
            if let selectedIndexPath = indexPath {
                //This case will allow new values so it must be cast/converted to an ItemCell
                let cell = tableView.cellForRow(at: selectedIndexPath) as! ItemCell
                
                //Call configureCell method
                configureCell(cell: cell, indexPath: indexPath!)
            }
        case .move:
            if let selectedIndexPath = indexPath {
                tableView.deleteRows(at: [selectedIndexPath], with: .fade)
            }
            if let selectedIndexPath = newIndexPath {
                tableView.insertRows(at: [selectedIndexPath], with: .fade)
            }
            break
        }
        
    }
    
    //New instances of the Item Entity
    func generateTestData() {
//        let newItem1 = Item(context: context)
//        newItem1.title = "Mac Book Pro"
//        newItem1.price = 1700
//        newItem1.details = "New touchbar seems cool but idk how I feel about the no USB ports"
//        
//        let newItem2 = Item(context: context)
//        newItem2.title = "Gulfstream G650"
//        newItem2.price = 65000000
//        newItem2.details = "Can't wait to sail across the world in my very own private jet"
//        
//        let newItem3 = Item(context: context)
//        newItem3.title = "Dingo Bay"
//        newItem3.price = 300000000
//        newItem3.details = "Living in my own personal island couldn't feel any better"
//        
//        let newItem4 = Item(context: context)
//        newItem4.title = "BMW M3"
//        newItem4.price = 85000
//        newItem4.details = "Cruising down the block in my M3"
//        
//        let newItem5 = Item(context: context)
//        newItem5.title = "NY Mansion"
//        newItem5.price = 25000000
//        newItem5.details = "Giving my family and I the home we never had"
//        
//        //Save to Core Data Managed Objects
//        ad.saveContext()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Allow tableView to conform to the protocols and dataSources of the ViewController
        tableView.delegate = self
        tableView.dataSource = self
        
        //Call
        generateTestData()
        attemptFetch()
    }

}

