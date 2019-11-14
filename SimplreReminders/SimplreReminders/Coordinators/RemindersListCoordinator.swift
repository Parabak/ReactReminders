//
//  RemindersListCoordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 09/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action


final class RemindersListCoordinator: Coordinator {
    
    let disposeBag = DisposeBag()
    var coordinators = [Coordinator]()
    let navController: UINavigationController
    let dataProvider: DataProvider
    var settings = Settings()
    
    init(navigationController: UINavigationController, dataProvider: DataProvider) {
        navController = navigationController
        self.dataProvider = dataProvider
    }
    
    
    func start() {
                   
        let model = RemindersViewModel(dataProvider: dataProvider, settings: settings)
        let controller = RemindersViewController(viewModel: model)
        //TODO: use Scene and SceneCoordinatorInstead
        navController.pushViewController(controller, animated: false)
        
        bindActions(from: model)
    }
    
    
    private func bindActions(from model: RemindersViewModel) {
        
        model.addReminder.subscribe(onNext: { [weak self] reminder in
            
            guard let self = self else { return }
            let editCoordinator = EditReminderCoordinator(navigationController: self.navController,
                                                          reminder: reminder,
                                                          categoriesProvider: self.dataProvider,
                                                          closeAction: self.closeAction())
            editCoordinator.start()
        }).disposed(by: disposeBag)
        
        model.showSettings
            .subscribe(onNext: { [weak self] _ in
                
                guard let self = self, let topController = self.navController.topViewController else { return }
                let coordinator = SettingsCoordinator(presentingController: topController,
                                                      settings: self.settings,
                                                      categoriesProvider: self.dataProvider,
                                                      closeAction: self.closeAction())
                coordinator.start()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func closeAction() -> CocoaAction {
        
        return CocoaAction {
            
            let subject = PublishSubject<Void>()
            self.navController.dismiss(animated: true) {
                subject.onCompleted()
            }
            
            return subject
        }
    }
}
