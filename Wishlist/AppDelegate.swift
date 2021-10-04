//
//  AppDelegate.swift
//  Wishlist
//
//  Created by fyz on 5/24/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var managedObjectContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WishlistModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return container
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navController = window!.rootViewController as! UINavigationController
        let maincontroller = navController.viewControllers.first as! MainViewController
        maincontroller.managedObjectContext = managedObjectContext
        
        listenForFatalCoreDataNotifications()
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        let message = url.host?.removingPercentEncoding
        
        let myArray = message?.components(separatedBy: "wishlistListID")
        let encodedUrl = myArray![0]
        let encodedListId = myArray![1]

        let decodedDataUrl = Data(base64Encoded: encodedUrl)!
        let url = String(data: decodedDataUrl, encoding: .utf8)!
        print(url)
        let decodedDataListId = Data(base64Encoded: encodedListId)!
        let listId = String(data: decodedDataListId, encoding: .utf8)!
        print(listId)
        
        let wish = Wysh(context: managedObjectContext)
        wish.url = url
        wish.listId = Int(listId)! as NSNumber
        wish.imageId = Wysh.nextPhotoID() as NSNumber
        if let data = UIImageJPEGRepresentation(UIImage(named: "Giftbox")!, 0.5) {
            do {
                try data.write(to: wish.photoURL, options: .atomic)
            } catch {
                print("Error writing file: \(error)")
            }
        }
        wish.name = "Wish from web"
        
        do{
            try managedObjectContext.save()
            afterDelay(0.6){
                
            }
        }catch{
            fatalCoreDataError(error)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func listenForFatalCoreDataNotifications() {
        // 1
        NotificationCenter.default.addObserver(
            forName: CoreDataSaveFailedNotification,
            object: nil, queue: OperationQueue.main,
            using: { notification in
                let message = "There was a fatal error in the app, please try agan later"
                let alert = UIAlertController( title: "Internal Error", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in
                    let exception = NSException(
                        name: NSExceptionName.internalInconsistencyException,
                        reason: "Fatal Core Data error", userInfo: nil)
                    exception.raise()
                }
                alert.addAction(action)
                let tabController = self.window!.rootViewController!
                tabController.present(alert, animated: true, completion: nil)
        })
    }
}

