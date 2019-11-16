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
    let disposeBag = DisposeBag()
    
    let navController: UINavigationController
    let reminder: ReminderItem?
    let dataProvider: DataProvider
    let onCloseAction: CocoaAction
    
    init(navigationController: UINavigationController,
         reminder: ReminderItem?,
         categoriesProvider: DataProvider,
         closeAction: CocoaAction) {
    
        self.navController = navigationController
        self.reminder = reminder
        self.dataProvider = categoriesProvider
        self.onCloseAction = closeAction
    }
    
    
    func onUpdate(reminder: ReminderItem?) -> Action<ReminderUpdateState, Void> {
        return Action {  newReminderState in
            
            let observable : Observable<ReminderItem>
            
            if let reminder = reminder {
                
                observable = self.dataProvider.update(reminder: reminder,
                                                      toState: newReminderState)
            } else {
                
                observable = self.dataProvider.createReminder(title: newReminderState.title,
                                                              category: newReminderState.category,
                                                              dueDate: newReminderState.date,
                                                              withNotification: newReminderState.hasNotification)
            }
            
            observable
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { reminder in
                        
                    //TODO: create or cancel Local Notification
//                    DispatchQueue.main.async {

                        if reminder.hasNotification {
                            
                            UNUserNotificationCenter.current().createNotificationIfNotExist(from: reminder)
                            
                        } else {
                            
                            UNUserNotificationCenter.current().cancelReminderNotification(for: reminder.uid.description)
                        }
                        
//                    }
                    
                }, onCompleted: { [weak self] in
                    self?.onCloseAction.execute()
                })
                .disposed(by: self.disposeBag)
            
            return observable.map {_ in }
        }
    }
    
    
    func start() {
        
        let model = EditReminderViewModel(reminder: reminder,
                                          categoriesProvider: dataProvider,
                                          updateAction: onUpdate(reminder: reminder),
                                          cancelAction: onCloseAction)
        let controller = EditReminderViewController(viewModel: model)
        let modalNavController = UINavigationController(rootViewController: controller)
        navController.present(modalNavController, animated: true, completion: nil)
    }
}
