//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Muhammad Ilham Ashiddiq Tresnawan on 03/08/20.
//  Copyright © 2020 Muhammad Ilham Ashiddiq Tresnawan. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var titles = [String]()
    var recordIDs = [CKRecord.ID]()
    
    //let privateDatabase = CKContainer.default().privateCloudDatabase
    let publicDatabase = CKContainer(identifier: "iCloud.com.m477.BabiFud").publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func saveBtn(_ sender: Any) {
        
        //CKContainer(identifier: "ICloud.com.m477.BabiFud")
        
        let title = textField.text!
        
        let record = CKRecord(recordType: "Note")
        
        record.setValue(title, forKey: "title")
        
        publicDatabase.save(record){ (savedRecord, error) in
            
            DispatchQueue.main.async {
                
            if error == nil {
                
                print("Record Saved")
                print("\(title) saved")
            } else {
                
                print("Record Not Saved")
                print("\(title) not saved")
            }
            
        }
    }
    }
    
    @IBAction func retrieveBtn(_ sender: Any) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Note", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
        titles.removeAll()
        recordIDs.removeAll()
        
        operation.recordFetchedBlock = { record in
            
            self.titles.append(record["title"]!)
            self.recordIDs.append(record.recordID)
            
        }
        
        operation.queryCompletionBlock = { cursor, error in
            
            DispatchQueue.main.async {
                
                print("Titles: \(self.titles)")
                print("RecordIDs: \(self.recordIDs)")
                
            }
            
        }
        
         publicDatabase.add(operation)
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        
        let newTitle = "Anything But The Old Title"
        
        let recordID = recordIDs.first!
        
        //let publicDatabase =  CKContainer(identifier: "ICloud.com.m477.BabiFud").publicCloudDatabase
        
        publicDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if error == nil {
                
                record?.setValue(newTitle, forKey: "title")
                
                self.publicDatabase.save(record!, completionHandler: { (newRecord, error) in
                    
                    if error == nil {
                        
                        print("Record Saved")
                        
                    } else {
                        
                        print("Record Not Saved")
                        
                    }
                    
                })
                
            } else {
                
                print("Could not fetch record")
                
            }
            
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        let recordID = recordIDs.first!
        
         publicDatabase.delete(withRecordID: recordID) { (deletedRecordID, error) in
            
            if error == nil {
                
                print("Record Deleted")
                
            } else {
                
                print("Record Not Deleted")
                
            }
            
        }
    }
}

