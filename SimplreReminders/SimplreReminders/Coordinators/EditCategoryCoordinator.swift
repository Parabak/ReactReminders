//
//  EditCategoryCoordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 15/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action


final class EditCategoryCoordinator: Coordinator {
    
    var coordinators = [Coordinator]()
    
    let categoryProvider: CategoryServiceType
    let navController: UINavigationController
    let categoryItem: CategoryItem?
    
    
    init(navigationController: UINavigationController,
         categoryService: CategoryServiceType,
         item: CategoryItem? = nil) {
        
        navController = navigationController
        categoryProvider = categoryService
        categoryItem = item
    }
    
    
    func start() {
        
        let model = EditCategoryViewModel(category: categoryItem,
                                          onUpdate: onUpdateColor(category: categoryItem))
        
        let controller = EditCategoryViewController(viewModel: model)
        navController.pushViewController(controller, animated: true)
    }
    
    
    func onUpdateColor(category: CategoryItem?) -> Action<CategoryState, Void> {
        
        return Action { state in
            
            let result: Observable<CategoryItem>
            if let category = category {
                
                result = self.categoryProvider.changeColor(category: category,
                                                           to: state.color)
            } else {
              
                result = self.categoryProvider.createCategory(name: state.name,
                                                             color: state.color)
            }
            
            self.navController.popViewController(animated: true)
            
            return result.map { _ in }
        }
    }
}
