//
//  EditReminderCoordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action


final class EditReminderCoordinator: Coordinator {
    
    var coordinators = [Coordinator]()
    let navController: UINavigationController
    let reminder: ReminderItem?
    let dataProvider: DataProvider

    
    init(navigationController: UINavigationController,
         reminder: ReminderItem,
         categoriesProvider: DataProvider) {
    
        self.navController = navigationController
        self.reminder = reminder
        self.dataProvider = categoriesProvider
    }
    
    
    func onUpdate(reminder: ReminderItem?) -> Action<ReminderUpdateState, Void> {
        return Action { newReminderState in
            
            if newReminderState.title.isEmpty {
                
                return self.dataProvider.createReminder(title: newReminderState.title,
                                                        category: newReminderState.category,
                                                        dueDate: newReminderState.date).map {_ in }
                
            } else if let reminder = reminder {
                
                return self.dataProvider.update(reminder: reminder,
                                                toState: newReminderState).map { _ in }
            } else {
                
                return Observable.empty()
            }
        }
    }
    
    
    func onCancel() -> CocoaAction {
        
        return CocoaAction {
            
            let subject = PublishSubject<Void>()
            self.navController.dismiss(animated: true) {
                subject.onCompleted()
            }
            
            return subject
        }
    }
    
    
    func start() {
        
        let model = EditReminderViewModel(reminder: reminder,
                                          categoriesProvider: dataProvider,
                                          updateAction: onUpdate(reminder: reminder),
                                          cancelAction: onCancel())
//        let controller = EditReminderViewController(
    }
}
