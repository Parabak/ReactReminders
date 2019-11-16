//
//  UNMutableNotificationContent+Reminder.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 16/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UserNotifications


extension UNNotificationRequest {
    
    convenience init(reminderName: String, categoryName: String, date: Date, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Task in \(categoryName)"
        content.body = reminderName
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute],
                                                             from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: false)
        
        self.init(identifier: identifier, content: content, trigger: trigger)
    }
}


extension UNUserNotificationCenter {
    
    
    func createNotificationIfNotExist(from reminder: ReminderItem) -> Void {
    
        let request = UNNotificationRequest(reminderName: reminder.title,
                                            categoryName: reminder.category?.name ?? "your inbox",
                                            date: reminder.dueDate,
                                            identifier: reminder.uid.description)
        
        getPendingNotificationRequests { requests in
            
            if (requests.filter { $0.identifier == request.identifier }).isEmpty {
                
                self.add(request)
            } else {
                
                self.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                self.add(request)
            }
        }
    }
    
    
    func cancelReminderNotification(for reminderId: String) -> Void {
        
        self.removePendingNotificationRequests(withIdentifiers: [reminderId])
    }
}
