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
    
    
    init(title: String, date: Date, category: CategoryItem?) {
    
        self.title = title
        self.date = date
        self.category = category
    }
    
    
    init() {
        self.title = ""
        let now = Date()
        self.date = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        self.category = nil
    }
}


struct EditReminderViewModel {
    
    let reminderState: ReminderUpdateState
    let onUpdate: Action<ReminderUpdateState, Void>
    let onCancel: CocoaAction?
    private let categoriesProvider: CategoryServiceType
    private  let disposeBag = DisposeBag()
    
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
    
    
    var categories: Observable<[CategoryItem]> {
        
        return categoriesProvider.categories()
            .map{ $0.toArray() }
            .observeOn(MainScheduler.instance)
    }
}
