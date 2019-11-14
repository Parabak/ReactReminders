//
//  SettingsCoordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 14/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import Action


final class SettingsCoordinator: Coordinator {
    
    var coordinators = [Coordinator]()
    let settings: Settings
    let presentingController: UIViewController
    let categoriesProvider: CategoryServiceType
    let closeAction: CocoaAction
    
    init(presentingController: UIViewController,
         settings: Settings,
         categoriesProvider: CategoryServiceType,
         closeAction: CocoaAction) {
    
        self.presentingController = presentingController
        self.settings = settings
        self.categoriesProvider = categoriesProvider
        self.closeAction = closeAction
    }
    
    
    func start() {
        
        let model = SettingsViewModel(categoriesProvider: categoriesProvider,
                                      settings: settings,
                                      onCancel: closeAction)
        let controller = SettingsViewController(viewModel: model)
        let navController = UINavigationController(rootViewController: controller)
        presentingController.present(navController, animated: true, completion: nil)
    }
}
