//
//  ViewController.swift
//  Wishlist
//
//  Created by fyz on 5/24/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    ////////// PROPERTIES /////////////////
    
    var managedObjectContext: NSManagedObjectContext!
    
    var readNames = [List]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addListButton(_ sender: Any) {
        performSegue(withIdentifier: "addListSegue", sender: self)
    }
    
    ////////// END PROPERTIES /////////////////
    

    ////////// DELEGATE FUNCTIONS /////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    ////////// END DELEGATE FUNCTIONS /////////////////
    
    func loadData(){
        let fetchRequest = NSFetchRequest<List>()
        let entity = List.entity()
        fetchRequest.entity = entity
        
        let filter = "0"
        
        let predicate = NSPredicate(format: "id != %@", filter)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            readNames = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    
    ////////// TABLE VIEW RELATED FUNCTIONS /////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        cell.textLabel?.text = readNames[indexPath.row].name
        return cell
    }
    //selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
//    //slide delete tableview row
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.readNames.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    //right to left slide to delete tableview row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var wishToDelete:Wysh = Wysh(context: self.managedObjectContext)
            var wishesList = [Wysh]()
            let list = readNames[indexPath.row]
            let listNameId = list.id
            
            let fetchRequest = NSFetchRequest<Wysh>()
            let entity = Wysh.entity()
            fetchRequest.entity = entity
            let filter = String(listNameId as! Int)
            
            let predicate = NSPredicate(format: "listId = %@", filter)
            fetchRequest.predicate = predicate
            
            do {
                wishesList = try managedObjectContext.fetch(fetchRequest)
            } catch {
                fatalCoreDataError(error)
            }
            
            for wish in wishesList{
                wishToDelete = wish
                self.managedObjectContext.delete(wishToDelete)
                do{
                    try self.managedObjectContext.save()
                } catch{
                    fatalCoreDataError(error)
                }
            }
            
            var listToDelete:List = List(context: self.managedObjectContext)
            listToDelete = list
            self.managedObjectContext.delete(listToDelete)
            do{
                try self.managedObjectContext.save()
            } catch{
                fatalCoreDataError(error)
            }
            
//            let userDefaults = UserDefaults(suiteName: "group.wl.extension")!
//            userDefaults.removeObject(forKey: "MyLists")
            
            self.loadData()
            tableView.reloadData()
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    ////////// END TABLE VIEW RELATED FUNCTIONS /////////////////
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //sending list name to ShowListViewController as title
        if (segue.identifier == "showListSegue") {
            if let showListViewController = segue.destination as? ShowListViewController {
                let indexPath = tableView.indexPathForSelectedRow
                let index = indexPath?.row
                showListViewController.title = readNames[index!].name
                
                showListViewController.listNameId = readNames[index!].id as! Int
                showListViewController.managedObjectContext = managedObjectContext
            }
        }
        
        if (segue.identifier == "addListSegue") {
            if let addListViewController = segue.destination as? AddListViewController {
                addListViewController.managedObjectContext = managedObjectContext
            }
        }
    }
}
  





