//
//  addListViewController.swift
//  Wishlist
//
//  Created by fyz on 5/24/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

class AddListViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var textFieldName: UITextField!

    @IBAction func saveListButton(_ sender: Any) {
        if ((textFieldName.text?.trimmingCharacters(in: .whitespaces))?.isEmpty)!{
            textFieldName.layer.borderColor = UIColor.red.cgColor
            return
        }
        let list = List(context: managedObjectContext)
        list.name = textFieldName.text
        list.id = List.nextListID() as NSNumber


        do {
            try managedObjectContext.save()
            addListToNSUserDefaults(list: list)
            afterDelay(0.6) {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
//        var listName: [ListName] = readListNames()
//        print("\(String(describing: listName[2].listName))")
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func addListToNSUserDefaults(list: List){
        let userDefaults = UserDefaults(suiteName: "group.mywishlist.extension")!
        if let mylists = userDefaults.dictionary(forKey: "MyLists"){
            var listeler = mylists
            listeler[list.name!] = list.id
            userDefaults.set(listeler, forKey: "MyLists")
        }
        else {
            var listeler: [String: Int] = [String: Int]()
            listeler[list.name!] = list.id as? Int
            userDefaults.set(listeler, forKey: "MyLists")
        }
        userDefaults.synchronize()
    }
    



}
