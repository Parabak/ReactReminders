//
//  Reminder.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift


class ReminderItem: Object {
    
    @objc dynamic var uid: Int = 0
    @objc dynamic var dueDate: Date?
    @objc dynamic var categoryId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    
    @objc override class func primaryKey() -> String? {
        return "uid"
    }
}

