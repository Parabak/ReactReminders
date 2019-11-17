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

 
struct SettingsViewModel: ViewModelType {
    
    let addCategory = PublishSubject<CategoryItem?>()
    private let categoriesProvider: CategoryServiceType
    let settings: Settings
    let onCancel: CocoaAction?
    let disposeBag = DisposeBag()
    let title = "Settings"
    
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
    
    
    func onAddCategory() -> CocoaAction {
        
        return CocoaAction {
            
            self.addCategory.onNext(nil)
            return .empty()
        }
    }
    
    
    
    
    func onSelect() -> Action<CategoryItem, Void> {
        
        let action = Action<CategoryItem, Void> { categoryItem -> Observable<Void> in
            
            self.addCategory.onNext(categoryItem)
            return .empty()
        }
        
        return action
    }
    
    
    lazy var selectCategory: Action<CategoryItem, Void> = { this in
        
        return Action<CategoryItem, Void> { category -> Observable<Void> in
            
            this.addCategory.onNext(category)
            return Observable.empty()
        }
    }(self)
 }
 
 
 
