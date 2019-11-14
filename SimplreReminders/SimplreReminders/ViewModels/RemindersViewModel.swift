//
//  RemindersViewModel.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 09/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxDataSources


typealias ReminderSection = AnimatableSectionModel<String, ReminderItem>


struct RemindersViewModel {

    let addReminder = PublishSubject<ReminderItem?>()
    let showSettings = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let dataProvider: ReminderServiceType
    let settings: Settings
    
    
    var sectionedReminders: Observable<[ReminderSection]> {
            
        return Observable.combineLatest(dataProvider.reminders(),
                                        settings.sortingOption)
            .map { arg in
                
                let reminders = arg.0

                func compare(lhs: ReminderItem, rhs: ReminderItem) -> Bool {
                    switch arg.1 {
                    case .alphabetical:
                        return lhs.title < rhs.title
                    case .date:
                        return lhs.dueDate < rhs.dueDate
                    }
                }
                
                let active = reminders.filter { !$0.isDone }.sorted(by: compare(lhs:rhs:))
                let done = reminders.filter { $0.isDone }.sorted(by: compare(lhs:rhs:))
 
                return [
                    ReminderSection(model: "Incomplete", items: active),
                    ReminderSection(model: "Done", items: done)
                ]
        }
    }
    
    
    func delete(item: ReminderItem) -> Void {

        dataProvider.delete(reminder: item)
    }
    
    
    func onAddReminder() -> CocoaAction {
                
        return CocoaAction { _ -> Observable<Void> in
            
            self.addReminder.onNext(nil)
            return .empty()
        }
    }
    
    
    func onOpenSettings() -> CocoaAction {
        
        return CocoaAction { _ -> Observable<Void> in
            
            self.showSettings.onNext(())
            return .empty()
        }
    }
    
    
    lazy var selectReminder: Action<ReminderItem, Void> = { this in
        
        let action = Action<ReminderItem, Void> { reminder -> Observable<Void> in
            
            this.addReminder.onNext(reminder)
            return Observable.empty()
        }
        return action
    }(self)
    
        
    func onToggle(item: ReminderItem) -> CocoaAction {
        
        return CocoaAction {
            self.dataProvider.toggle(reminder: item).map { _ in }
        }
    }
}
