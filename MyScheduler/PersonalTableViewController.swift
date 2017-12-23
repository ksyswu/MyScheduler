//
//  PersonalTableViewController.swift
//  MyScheduler
//
//  Created by SWUCOMPUTER on 2017. 12. 2..
//  Copyright © 2017년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class PersonalTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var personalTab: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
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

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData() //기존에것에 추가 하는 것
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.per.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pschedule Cell", for: indexPath)
        
        let per2 = appDelegate.per[indexPath.row]
        var display: String = ""
        if let nameLabel = per2.value(forKey: "ptitle") as? String {
            display = nameLabel }
        if let phoneLabel = per2.value(forKey: "pdate") as? String { cell.detailTextLabel?.text = phoneLabel
        }
        cell.textLabel?.text = display
        
        return cell
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(appDelegate.per[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            // 배열에서 해당 자료 삭제
            appDelegate.per.remove(at: indexPath.row)
            // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            personalTab.badgeValue = String(format: "%d", appDelegate.per.count) // 아이콘의 badge number 변경

            let application = UIApplication.shared
            application.applicationIconBadgeNumber = appDelegate.per.count + appDelegate.sch.count
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPdetailScheduleView" {
            if let destination = segue.destination as? PdetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.pdetailSchedule = appDelegate.per[selectedIndex] //선택된 인덱스를 디테일로 보냄
                }
            }
        }
    }
    
}
