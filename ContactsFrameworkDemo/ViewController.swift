//
//  ViewController.swift
//  ContactsFrameworkDemo
//
//  Created by Peng Xie on 2/9/16.
//  Copyright © 2016 CogentIBS. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    let store = CNContactStore();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteContactsButtonDidPushed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Warning",
            message: "Do you really wanna delete ALL your contacts?",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "HELL YEAH",
            style: .Destructive,
            handler: { (action) -> Void in
                self.deleteAllContacts(self.store)
        }))
        alertController.addAction(UIAlertAction(title: "Nope",
            style: .Cancel,
            handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteGroupsButtonDidPushed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Warning",
            message: "Do you really wanna delete ALL your groups?",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "HELL YEAH",
            style: .Destructive,
            handler: { (action) -> Void in
                self.deleteAllGroups(self.store)
        }))
        alertController.addAction(UIAlertAction(title: "Nope",
            style: .Cancel,
            handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteAllContacts(store: CNContactStore) {
        do {
            let predicate = CNContact.predicateForContactsInContainerWithIdentifier(store.defaultContainerIdentifier())
            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: [CNContactPhoneNumbersKey])
            
            let saveRequest = CNSaveRequest()
            for contact in contacts {
                saveRequest.deleteContact(contact.mutableCopy() as! CNMutableContact)
            }
            try store.executeSaveRequest(saveRequest)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let alertController = UIAlertController(title: "Done", message: "Shhh, only dream now...", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
        catch let error as NSError {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func deleteAllGroups(store: CNContactStore) {
        do {
            let predicate = CNGroup.predicateForGroupsInContainerWithIdentifier(store.defaultContainerIdentifier())
            let groups = try store.groupsMatchingPredicate(predicate)
            
            let saveRequest = CNSaveRequest()
            for group in groups {
                saveRequest.deleteGroup(group.mutableCopy() as! CNMutableGroup)
            }
            try store.executeSaveRequest(saveRequest)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let alertController = UIAlertController(title: "Done", message: "Shhh, only dream now...", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
        catch let error as NSError {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
}

