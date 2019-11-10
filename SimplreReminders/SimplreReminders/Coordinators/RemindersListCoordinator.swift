//
//  RemindersListCoordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 09/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit


final class RemindersListCoordinator : Coordinator {
    
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
    }
}
