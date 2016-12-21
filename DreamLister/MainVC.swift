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
        
        //Perform the fetching
        do {
            try controller.performFetch()
            
        }catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

