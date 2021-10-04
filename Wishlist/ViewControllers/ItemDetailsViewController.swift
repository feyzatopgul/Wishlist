//
//  ItemDetailsViewController.swift
//  Wishlist
//
//  Created by fyz on 7/4/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, TakePhotoViewControllerDelegate  {
    
    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishNameLabel: UILabel!
    @IBOutlet weak var wishPriceLabel: UILabel!
    @IBOutlet weak var wishUrlLabel: UILabel!
    @IBOutlet weak var wishNotesLabel: UILabel!
    @IBOutlet weak var wishStoreLabel: UILabel!
    var currentWish: Wysh!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var savePressed: Bool? = nil
    var listNameId = Int()
    func savePressed(saveButtonPressed: Bool?) {
        savePressed = saveButtonPressed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishImage.image = currentWish.photoImage
        self.wishNameLabel.text = currentWish.name
        
        if let price = currentWish.price{
            self.wishPriceLabel.text = String(price as! Int)
        }
        
        self.wishStoreLabel.text = currentWish.store
        self.wishUrlLabel.text = currentWish.url
        self.wishNotesLabel.text = currentWish.notes

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditItemSegue") {
            if let takePhotoViewController = segue.destination as? TakePhotoViewController{
                takePhotoViewController.wishToEdit = currentWish
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
 
    
}
