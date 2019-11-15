//
//  CategoryServiceType.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


protocol CategoryServiceType {
    
    @discardableResult
    func createCategory(name: String,
                        color: Color) -> Observable<CategoryItem>
    
    @discardableResult
    func changeColor(category: CategoryItem,
                     to newColor: Color) -> Observable<CategoryItem>
    
    func categories() -> Observable<Results<CategoryItem>>
}

