//
//  ReminderServiceType.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


protocol ReminderServiceType {
    
    @discardableResult
    func createReminder(title: String,
                        category: CategoryItem,
                        dueDate: Date?) -> Observable<ReminderItem>
    
    @discardableResult
    func delete(reminder: ReminderItem) -> Observable<Void>
    
    @discardableResult
    func update(reminder: ReminderItem, title: String) -> Observable<ReminderItem>
    
    @discardableResult
    func toggle(reminder: ReminderItem) -> Observable<ReminderItem>
    
    func reminders() -> Observable<Results<ReminderItem>>
}
