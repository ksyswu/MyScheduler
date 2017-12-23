//
//  DetailViewController.swift
//  MyScheduler
//
//  Created by SWUCOMPUTER on 2017. 12. 2..
//  Copyright © 2017년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet var date: UITextField!
    @IBOutlet var theme: UITextField!
    @IBOutlet var content: UITextView!
    
    var detailSchedule: NSManagedObject?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let sch2 = detailSchedule {
            date.text = sch2.value(forKey: "date") as? String
            theme.text = sch2.value(forKey: "title") as? String
            content.text = sch2.value(forKey: "content") as? String
            
        }
    }
    
    
    @IBAction func toBack(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddAlram"{
            if let destination = segue.destination as? AlramViewController{
                
                destination.getTitle = theme.text!
              
                
            }
        }
    }
    


}
