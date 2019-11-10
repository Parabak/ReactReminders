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
    let navController : UINavigationController
    
    init(navigationController: UINavigationController) {
        navController = navigationController
    }
    
    
    func start() {
        
        let model = RemindersViewModel()
        let controller = RemindersViewController(viewModel: model)
        //TODO: use Scene and SceneCoordinatorInstead
        navController.pushViewController(controller, animated: false)
    }
}
