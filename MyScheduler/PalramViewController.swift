//
//  PalramViewController.swift
//  MyScheduler
//
//  Created by SWUCOMPUTER on 2017. 12. 23..
//  Copyright © 2017년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class PalramViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var getTheme: UITextField!
    
    var getTitle: String = ""
    
    var eventStore: EKEventStore?//미리알림 앱 데이터에 접근하기 위해
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTheme.text = getTitle
        
    }
    
    
    
    func saveSettings() {
        if self.eventStore == nil {
            self.eventStore = EKEventStore()
            // 접근권한 요청
            self.eventStore!.requestAccess(to: EKEntityType.reminder, completion:
                {(isAccessible,errors) in })
        }
        
        // 이 앱을 통해 저장한 이전의 모든 알림 삭제 그전에 있던 알람들 이름 같은거 여러개를 하나로 통합시키는것..?
        let predicateForEvents:NSPredicate = self.eventStore!.predicateForReminders(in: [self.eventStore!.defaultCalendarForNewReminders()])
        self.eventStore!.fetchReminders (matching: predicateForEvents, completion: { (reminders) in
            for reminder in reminders! {
                if reminder.title == self.getTheme.text! {
                    do {
                        try self.eventStore!.remove(reminder, commit: true)
                    } catch {
                    }
                }
            } })
        
        let reminder = EKReminder(eventStore: self.eventStore!)
        reminder.title = getTheme.text!
        
        reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
        let alarm = EKAlarm(absoluteDate: datePicker.date)
        reminder.addAlarm(alarm)
        do {
            try self.eventStore!.save(reminder, commit: true)
        } catch {
            NSLog("미리 알림 설정 실패") }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let currentDate = Date()
        datePicker.minimumDate = currentDate
    }
    
    @IBAction func alramAdd(_ sender: UIButton) {
        saveSettings()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}



