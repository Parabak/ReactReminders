//
//  Reminder.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources


class ReminderItem: Object {
    
    @objc dynamic var uid: Int = 0
    @objc dynamic var dueDate = Date()
    @objc dynamic var category: CategoryItem?
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var hasNotification = false
    
    @objc override class func primaryKey() -> String? {
        return "uid"
    }
    
    convenience init(title: String, dueDate: Date, category: CategoryItem?, hasNotification: Bool) {
        
        self.init()
        self.title = title
        self.dueDate = dueDate
        self.category = category
        self.hasNotification = hasNotification
    }
}


extension ReminderItem: IdentifiableType {

    var identity: Int {
        return isInvalidated ? 0 : uid
    }
}

extension ReminderItem {
    
    static func == (lhs: ReminderItem, rhs: ReminderItem) -> Bool {
        return lhs.uid == rhs.uid && lhs.title == rhs.title
    }
}
