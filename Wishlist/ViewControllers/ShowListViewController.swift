//
//  ShowListViewController.swift
//  Wishlist
//
//  Created by fyz on 6/21/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

class ShowListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
   
    @IBOutlet weak var tableView: UITableView!
        
    var managedObjectContext: NSManagedObjectContext!
    var wishesList = [Wysh]()
    var listNameId: Int!
    
    ////////// DELEGATE FUNCTIONS /////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }

    ////////// END DELEGATE FUNCTIONS /////////////////
    
    func loadData(){
        let fetchRequest = NSFetchRequest<Wysh>()
        let entity = Wysh.entity()
        fetchRequest.entity = entity
        let filter = String(listNameId)
        let predicate = NSPredicate(format: "listId = %@", filter)
        fetchRequest.predicate = predicate

        let sortDescriptor = NSSortDescriptor(key: "imageId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            wishesList = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    
    ////////// TABLE VIEW RELATED FUNCTIONS /////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.itemPhoto.image = wishesList[indexPath.row].photoImage
        cell.itemName.text = wishesList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //right to left slide to delete tableview row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var wishToDelete:Wysh = Wysh(context: self.managedObjectContext)
            wishToDelete = self.wishesList[indexPath.row]
            self.managedObjectContext.delete(wishToDelete)
            
            do{
                try self.managedObjectContext.save()
            } catch{
                fatalCoreDataError(error)
            }
            
            self.loadData()
            tableView.reloadData()
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    ////////// END TABLE VIEW RELATED FUNCTIONS /////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //sending listnameid to add item view controller
        if (segue.identifier == "addItemSegue") {
            if let addItemViewController = segue.destination as? AddItemViewController{
                addItemViewController.listNameId = listNameId
                addItemViewController.managedObjectContext = managedObjectContext
            }
        }
        else if (segue.identifier == "ItemDetailsSegue") {
            if let itemDetailsViewController = segue.destination as? ItemDetailsViewController{
                itemDetailsViewController.managedObjectContext = managedObjectContext
                if let indexPath = tableView.indexPath(for: sender as! ItemCell){
                    let wish = wishesList[indexPath.row]
                    itemDetailsViewController.currentWish = wish
                }
            }
        }
    }
    
    
    



}
