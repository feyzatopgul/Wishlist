
//  TakePhotoViewController.swift
//  Wishlist
//
//  Created by fyz on 6/24/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

protocol TakePhotoViewControllerDelegate {
    func savePressed(saveButtonPressed: Bool?)
}
    
class TakePhotoViewController: UIViewController{
    
    var managedObjectContext: NSManagedObjectContext!
    
    var observer: Any!
    var saveButtonPressed: Bool? = nil
    var delegate: TakePhotoViewControllerDelegate?
    
   
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var storeField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    

    var listNameId = Int()
    var image: UIImage?
    var wishToEdit: Wysh!
    
    @IBAction func cameraButton(_ sender: Any) {
        pickPhoto()
    }
    
    

    @IBAction func saveItemButton(_ sender: Any) {
        if ((nameField.text?.trimmingCharacters(in: .whitespaces))?.isEmpty)!{
            nameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        let wish: Wysh

        if let temp = wishToEdit {
            wish = temp
            fillWish(wish: wish)
            //Here is where we update the wish
        } else {
            wish = Wysh(context: managedObjectContext)
            fillWish(wish: wish)
            wish.url = ""
            wish.listId = listNameId as NSNumber
            //Here is where we save the wish
        }
        
        do{
            try managedObjectContext.save()
            afterDelay(0.6){
                
                self.saveButtonPressed = true
                self.delegate?.savePressed(saveButtonPressed: self.saveButtonPressed)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }catch{
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func cancelItemButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        
        if let currentWish = wishToEdit {
            nameField.text = currentWish.name
            if let wishPrice = currentWish.price{
                priceField.text = "\(wishPrice)"
            }
            storeField.text = currentWish.store
            notesField.text = currentWish.notes
            cameraView.image = currentWish.photoImage
            self.title = "Edit Wish"
        }
        
        super.viewDidLoad()
        
        //add an observer for the UIApplicationDidEnterBackground notification
        listenForBackgroundNotification()
    }
    
    func fillWish(wish:Wysh){
        
        // Save image
        
        if !wish.hasPhoto {
            wish.imageId = Wysh.nextPhotoID() as NSNumber
        
            
            if let image = image {
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    do {
                        try data.write(to: wish.photoURL, options: .atomic)
                    } catch {
                        print("Error writing file: \(error)")
                    }
                }
            }
            else{
                if let data = UIImageJPEGRepresentation(UIImage(named: "Giftbox")!, 0.5) {
                    do {
                        try data.write(to: wish.photoURL, options: .atomic)
                    } catch {
                        print("Error writing file: \(error)")
                    }
                }
            }
        }
        else{
            if let image = image {
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    do {
                        try data.write(to: wish.photoURL, options: .atomic)
                    } catch {
                        print("Error writing file: \(error)")
                    }
                }
            }
        }
        
        wish.name = nameField.text
        if let temp = Double(priceField.text!){
            let wishPrice = NSNumber(value: temp)
            wish.price = wishPrice
        }
        wish.store = storeField.text
        wish.notes = notesField.text
    }
    
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName:Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { [weak self] _ in
            if let weakSelf = self {
                if weakSelf.presentedViewController != nil {
                    weakSelf.dismiss(animated: false, completion: nil)
                }
                weakSelf.nameField.resignFirstResponder()
                weakSelf.priceField.resignFirstResponder()
                weakSelf.storeField.resignFirstResponder()
                weakSelf.notesField.resignFirstResponder()
            }
        }
    }
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer)
    }
}

extension TakePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
    
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let wishImage = image{
            cameraView.image = wishImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
