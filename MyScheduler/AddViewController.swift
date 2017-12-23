//
//  AddViewController.swift
//  MyScheduler
//
//  Created by SWUCOMPUTER on 2017. 12. 2..
//  Copyright © 2017년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet var date: UITextField!
    @IBOutlet var thema: UITextField!
    @IBOutlet var content: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //사용자 허가를 받는것 앱이 삭제되기전에 딱한 번 허락을 받음
        // "shared" returns the singleton app instance
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        // Requests authorization to interact with the user
        // when local and remote notifications arrive
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted {
                print("Approval granted to send notifications")

            }
            else {
                print(error!)
            }
            
            
        }
        application.registerForRemoteNotifications()
        
        // First VC 가 처음 실행되는 VC 이므로 이곳에 한번만 설정하면 됨
        application.applicationIconBadgeNumber = 0
    }
    
    
    
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) { //뷰가 나타나기전에 실행하는 것
        super.viewDidAppear(animated)
        
        let context = self.getContext() // 콘덱스트 함수 호출
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pschedule")//페치 리퀘서트 생성 모든 정보를 가져오는
        
        let sortDescriptor = NSSortDescriptor (key: "pdate", ascending: true)//정렬작업
        fetchRequest.sortDescriptors = [sortDescriptor] //여러개의 디스크립터를 함 - 똑같은 키값이 들어올 수도 있기 때문
        
        do { //실제로 실행
            appDelegate.per = try context.fetch(fetchRequest) //디비의 자료는 sch에 넣음
            
            let tabController = appDelegate.window?.rootViewController
            let tableVC = tabController?.childViewControllers[2] as! PersonalTableViewController
            tableVC.personalTab.badgeValue = String(format: "%d", tableVC.appDelegate.per.count)
            //tableVC.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Schedule")//페치 리퀘서트 생성 모든 정보를 가져오는
        
        let sortDescriptor2 = NSSortDescriptor (key: "date", ascending: true)//정렬작업
        fetchRequest2.sortDescriptors = [sortDescriptor2] //여러개의 디스크립터를 함 - 똑같은 키값이 들어올 수도 있기 때문
        
        do { //실제로 실행
            appDelegate.sch = try context.fetch(fetchRequest2) //디비의 자료는 sch에 넣음
            let tabController2 = appDelegate.window?.rootViewController
            let tableVC2 = tabController2?.childViewControllers[1] as! ScheduleTableViewController
            
            tableVC2.scheduleTab.badgeValue = String(format: "%d", appDelegate.sch.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

                let application = UIApplication.shared
                application.applicationIconBadgeNumber = appDelegate.per.count + appDelegate.sch.count
 
    }

    
    @IBAction func addPerson(_ sender: UIButton) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Pschedule", in: context)
        
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(date.text, forKey: "pdate")
        object.setValue(thema.text, forKey: "ptitle")
        object.setValue(content.text, forKey: "pcontent")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.per.append(object)
        
        let tabController = appDelegate.window?.rootViewController
        let tableVC = tabController?.childViewControllers[2] as! PersonalTableViewController
        tableVC.personalTab.badgeValue = String(format: "%d", appDelegate.per.count)
        
                let application = UIApplication.shared
                application.applicationIconBadgeNumber = appDelegate.per.count + appDelegate.sch.count
        
        date.text = ""
        thema.text = ""
        content.text = ""
    
    }
    
    
    @IBAction func addSche(_ sender: UIButton) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Schedule", in: context)
        
        
        let object2 = NSManagedObject(entity: entity!, insertInto: context)
        
        object2.setValue(date.text, forKey: "date")
        object2.setValue(thema.text, forKey: "title")
        object2.setValue(content.text, forKey: "content")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.sch.append(object2)
        
        let tabController2 = appDelegate.window?.rootViewController
        let tableVC2 = tabController2?.childViewControllers[1] as! ScheduleTableViewController
        
        tableVC2.scheduleTab.badgeValue = String(format: "%d", appDelegate.sch.count)
        
                let application = UIApplication.shared
                application.applicationIconBadgeNumber = appDelegate.per.count + appDelegate.sch.count
        
        date.text = ""
        thema.text = ""
        content.text = ""
    }
    
}
