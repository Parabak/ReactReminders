 //
//  SettingsViewModel.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 14/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action
import RxDataSources


typealias CategoriesSection = AnimatableSectionModel<String, CategoryItem>

 
struct SettingsViewModel {
    
    private let categoriesProvider: CategoryServiceType
    let settings: Settings
    let onCancel: CocoaAction?
    
    
    init(categoriesProvider: CategoryServiceType,
         settings: Settings,
         onCancel: CocoaAction?) {
    
        self.categoriesProvider = categoriesProvider
        self.settings = settings
        self.onCancel = onCancel
    }
    
    
    var sectionCategories: Observable<[CategoriesSection]> {
        
        return categoriesProvider.categories()
            .map { results in
                
                return [CategoriesSection(model: "Categories", items: results.toArray())]
            }
    }
    
    //TODO: Add category
    //TODO: Create Category. Implement like in Spendee
    //TODO: Edit Category
 }
 
 
 
