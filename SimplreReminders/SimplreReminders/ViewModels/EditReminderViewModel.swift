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
    
    init(reminderItem: ReminderItem) {
        
        self.title = reminderItem.title
        self.date = reminderItem.dueDate
        self.category = reminderItem.category
    }
    
    
    init() {
        self.title = ""
        self.date = Date()
        self.category = nil
    }
}


struct EditReminderViewModel {
    
    let reminderState: ReminderUpdateState
    let categoriesProvider: CategoryServiceType
    let onUpdate: Action<ReminderUpdateState, Void>
    let onCancel: CocoaAction?
    let disposeBag = DisposeBag()
    
    init(reminder: ReminderItem?,
         categoriesProvider: CategoryServiceType,
         updateAction: Action<ReminderUpdateState, Void>,
         cancelAction: CocoaAction? = nil) {
        
        if let reminder = reminder {
            reminderState = ReminderUpdateState(reminderItem: reminder)
        } else {
            reminderState = ReminderUpdateState()
        }
        
        self.categoriesProvider = categoriesProvider
        onUpdate = updateAction
        onCancel = cancelAction
    }
}
