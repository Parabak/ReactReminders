//
//  EditReminderViewModel.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RxSwift
import Action


struct ReminderUpdateState {
    
    let title: String
    let date: Date
    let category: CategoryItem?
    let hasNotification: Bool
    
    init(reminderItem: ReminderItem) {
        
        self.title = reminderItem.title
        self.date = reminderItem.dueDate
        self.category = reminderItem.category
        self.hasNotification = reminderItem.hasNotification
    }
    
    
    init(title: String, date: Date, category: CategoryItem?, hasNotification: Bool) {
    
        self.title = title
        self.date = date
        self.category = category
        self.hasNotification = hasNotification
    }
    
    
    init() {
        self.title = ""
        let now = Date()
        self.date = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        self.category = nil
        self.hasNotification = false
    }
}


struct EditReminderViewModel: ViewModelType {
    
    let reminderState: ReminderUpdateState
    let onUpdate: Action<ReminderUpdateState, Void>
    let onCancel: CocoaAction?
    let title: String
    private let categoriesProvider: CategoryServiceType
    private  let disposeBag = DisposeBag()
    
    init(reminder: ReminderItem?,
         categoriesProvider: CategoryServiceType,
         updateAction: Action<ReminderUpdateState, Void>,
         cancelAction: CocoaAction? = nil) {
        
        if let reminder = reminder {
            reminderState = ReminderUpdateState(reminderItem: reminder)
            title = "Edit Reminder"
        } else {
            reminderState = ReminderUpdateState()
            title = "Crete Reminder"
        }
        
        self.categoriesProvider = categoriesProvider
        onUpdate = updateAction
        onCancel = cancelAction
    }
    
    
    var categories: Observable<[CategoryItem]> {
        
        return categoriesProvider.categories()
            .map{ $0.toArray() }
            .observeOn(MainScheduler.instance)
    }
}
