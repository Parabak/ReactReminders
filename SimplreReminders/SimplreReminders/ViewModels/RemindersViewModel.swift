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


struct RemindersViewModel {

    let dataProvider: ReminderServiceType
    let addReminder: PublishSubject = PublishSubject<Void>()
    
    
    func onAddReminder() -> CocoaAction {
                
        return CocoaAction { _ -> Observable<Void> in
            self.addReminder.onNext(())
            return self.addReminder.asObservable()
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
