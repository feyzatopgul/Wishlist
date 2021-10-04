//
//  ShareViewController.swift
//  WishlistShareExtension
//
//  Created by fyz on 7/3/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    var urlToSave = String()
    private var lists = [String]()
    var dict:[String : Int] = [String : Int]()
    fileprivate var selectedList: String?
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    @objc func openURL(_ url: URL) {
        return
    }

    func openContainerApp(urlToSave:String) {
        let urlToSave = "Wishlist://\(urlToSave)"
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: urlToSave)!)
                return
            }
            responder = responder?.next
        }
    }

    var stringToSend : String = ""
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        var dataToSend = [String : Int]()
        let listaydi = dict[selectedList!]
        dataToSend[urlToSave] = listaydi
        print("dataToSend: \(dataToSend)")
//        let url = URL(string:"Wishlist://value")
//        self.extensionContext!.open(url!, completionHandler: nil)
        let dataUrl = (urlToSave).data(using: String.Encoding.utf8)
        let encodedUrl = dataUrl!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("encodedURL: \(String(describing: encodedUrl))")
        
        let strId = String(listaydi!)
        let idUrl = (strId).data(using: String.Encoding.utf8)
        let encodedId = idUrl!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("encodedId: \(String(describing: encodedId))")
        
        let encodedUrlId = "\(encodedUrl)wishlistListID\(encodedId)"
        print("encoded Url and Id: \(String(describing: encodedUrlId))")
        
        openContainerApp(urlToSave: encodedUrlId)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        if let list = SLComposeSheetConfigurationItem() {
            list.title = "Selected List"
            list.value = selectedList
            list.tapHandler = {
                let vc = ShareSelectViewController()
                vc.lists = self.lists
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [list]
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults(suiteName: "group.wl.extension")!
        if let mylists = userDefaults.dictionary(forKey: "MyLists"){
            print("\(mylists)")
            dict = mylists as! [String : Int]
            for (key, _) in mylists {
                lists.append(key)
            }
        }
        
        selectedList = lists.first
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let _ = NSURL(string: urlString) {
                        print("URL retrieved: \(urlString)")
                        self.urlToSave = urlString
                    }
                }
            })
        } else {
            print("error")
        }
        //print ("\(selectedList(0))")
    }
}
extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(list: String) {
        selectedList = list
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}

