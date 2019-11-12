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
    
    
    init(navigationController: UINavigationController, dataProvider: DataProvider) {
        navController = navigationController
        self.dataProvider = dataProvider
    }
    
    
    func start() {
        
        let model = RemindersViewModel(dataProvider: dataProvider)
        let controller = RemindersViewController(viewModel: model)
        //TODO: use Scene and SceneCoordinatorInstead
        navController.pushViewController(controller, animated: false)
        
        bindAddReminder(from: model)
    }
    
    
    private func bindAddReminder(from model: RemindersViewModel) {
        
//        model.addReminder.subscribe(onNext: { [weak self] _ in
//            
//            guard let self = self else { return }
//            let editCoordinator = EditReminderCoordinator(navigationController: self.navController,
//                                                          reminder: nil,
//                                                          categoriesProvider: self.dataProvider)
//            self.coordinators.append(editCoordinator)
//            editCoordinator.start()            
//        }).disposed(by: disposeBag)
        
    }
}
