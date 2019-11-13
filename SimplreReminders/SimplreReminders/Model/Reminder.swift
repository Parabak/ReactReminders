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
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    
    @objc override class func primaryKey() -> String? {
        return "uid"
    }
    
    convenience init(title: String, dueDate: Date, category: CategoryItem?) {
        
        self.init()
        self.title = title
        self.dueDate = dueDate
        self.category = category
    }
}


extension ReminderItem: IdentifiableType {

    var identity: Int {
        return isInvalidated ? 0 : uid
    }
}
