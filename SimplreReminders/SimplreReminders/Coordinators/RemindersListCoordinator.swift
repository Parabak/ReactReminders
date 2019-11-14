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
        
//        let pulisher = BehaviorSubject(value: settings)
//        let observable = Observable.of(settings)
                
//        pulisher.subscribe(onNext: { settings in
//            print(settings.sortOption.description)
//        }, onCompleted: {
//            print("completed")
//        }).disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.settings.changeSortOption(to: .date)
        }
        
        let model = RemindersViewModel(dataProvider: dataProvider, settings: settings)
        let controller = RemindersViewController(viewModel: model)
        //TODO: use Scene and SceneCoordinatorInstead
        navController.pushViewController(controller, animated: false)
        
        bindAddReminder(from: model)
    }
    
    
    private func bindAddReminder(from model: RemindersViewModel) {
        
        model.addReminder.subscribe(onNext: { [weak self] reminder in
            
            guard let self = self else { return }
            let editCoordinator = EditReminderCoordinator(navigationController: self.navController,
                                                          reminder: reminder,
                                                          categoriesProvider: self.dataProvider)
            self.coordinators.append(editCoordinator)
            editCoordinator.start()
        }).disposed(by: disposeBag)
    }
}
