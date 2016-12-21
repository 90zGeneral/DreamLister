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
    
    //Tell FRC to operate on the Item Entity/Data Class
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        
        //Perform the fetching with the possibility of failing
        do {
            try controller.performFetch()
            
        }catch {
            let error = error as NSError
            print("\(error)")
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

