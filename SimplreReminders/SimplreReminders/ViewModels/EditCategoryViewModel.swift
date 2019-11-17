//
//  EditCategoryViewModel.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 15/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action
import RxDataSources


typealias CategoryState = (name: String, color: Color)
typealias ColorSection = AnimatableSectionModel<String, Color>

struct EditCategoryViewModel: ViewModelType {

    var title: String {
        get {
            category != nil ? "Edit Category" : "Create Category"
        }
    }
    let category: CategoryItem?
    let onUpdate: Action<CategoryState, Void>
    
    var sectionedColors: Observable<[ColorSection]> {
        
        return  Observable.of(Color.allCases)
                .map { [AnimatableSectionModel(model: "", items: $0)] }
    }
}
