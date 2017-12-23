//
//  PdetailViewController.swift
//  MyScheduler
//
//  Created by SWUCOMPUTER on 2017. 12. 3..
//  Copyright © 2017년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class PdetailViewController: UIViewController {

    @IBOutlet var date: UITextField!
    @IBOutlet var theme: UITextField!
    @IBOutlet var content: UITextView!
    
    var pdetailSchedule: NSManagedObject?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let per2 = pdetailSchedule {
            date.text = per2.value(forKey: "pdate") as? String
            theme.text = per2.value(forKey: "ptitle") as? String
            content.text = per2.value(forKey: "pcontent") as? String
            
        }
    }
    
    @IBAction func toBack(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPalram"{
            if let destination = segue.destination as? PalramViewController{
                
                destination.getTitle = theme.text!
                
                
            }
        }
    }

}
