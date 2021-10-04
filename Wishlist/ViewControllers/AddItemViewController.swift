//
//  AddItemViewController.swift
//  Wishlist
//
//  Created by fyz on 6/24/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, TakePhotoViewControllerDelegate {
    
    var savePressed: Bool? = nil
    var listNameId = Int()
    
    func savePressed(saveButtonPressed: Bool?) {
        savePressed = saveButtonPressed
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "takePhotoSegue") {
            if let takePhotoViewController = segue.destination as? TakePhotoViewController {
                takePhotoViewController.listNameId = listNameId
                takePhotoViewController.managedObjectContext = managedObjectContext
                takePhotoViewController.saveButtonPressed = savePressed
                takePhotoViewController.delegate = self
                if savePressed == true {
                    let viewControllers = self.navigationController?.viewControllers
                    for viewController in viewControllers! {
                        if viewController is ShowListViewController {
                            _ = self.navigationController?.popToViewController(viewController as! ShowListViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func addFromWebButton(_ sender: Any) {
        if let url = URL(string: "http://google.com") {
            UIApplication.shared.open(url, options: [:])
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if savePressed == true {
            let viewControllers = self.navigationController?.viewControllers
            for viewController in viewControllers! {
                if viewController is ShowListViewController {
                    _ = self.navigationController?.popToViewController(viewController as! ShowListViewController, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
