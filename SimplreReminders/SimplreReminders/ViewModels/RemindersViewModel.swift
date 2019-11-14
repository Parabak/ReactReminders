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

    let dataProvider: ReminderServiceType
    let addReminder: PublishSubject = PublishSubject<ReminderItem?>()

    var sectionedReminders: Observable<[ReminderSection]> {
        
        return dataProvider.reminders()
            .map { reminders in
            
            //TODO: customize sorting by Settings.
            let active = reminders.filter { !$0.isDone }.sorted { (lhs, rhs) -> Bool in
                return lhs.title < rhs.title
            }
            
            let done = reminders.filter { $0.isDone }.sorted { (lhs, rhs) -> Bool in
                return lhs.title < rhs.title
            }
            
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
            return Observable.empty()
        }
    }
    
    
    lazy var selectReminder: Action<ReminderItem, Void> = { this in
        
        let t = Action<ReminderItem, Void> { reminder -> Observable<Void> in
            
            this.addReminder.onNext(reminder)
            return Observable.empty()
        }
        return t
    }(self)
    
        
    func onToggle(item: ReminderItem) -> CocoaAction {
        
        return CocoaAction {
            self.dataProvider.toggle(reminder: item).map { _ in }
        }
    }
    
    func openSettings() {
        
        // ViewController call openSettings, how to propogate it to RemindersListCoordinator?
        // Should RemindersListCoordinator subscribe for some observable?
        
        /* See
         

         private func bindShouldLoadWidget(from viewModel: DashboardContainerViewModel) {
             viewModel.rx_shouldLoadWidget.asObservable()
                 .subscribe(onNext: { [weak self] in
                     self?.loadWidgets()
                 })
                 .addDisposableTo(disposeBag)
         }
         
         */
        
        // To open settings I need to know about CategoryServiceType!
    }
}
