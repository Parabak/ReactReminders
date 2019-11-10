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
        
        model.addReminder.subscribe(onNext: { _ in
            print("Confirm: need to add")
        }).disposed(by: disposeBag)
        
    }
}
