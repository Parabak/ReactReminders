//
//  RealmDataProvider.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift


enum DataServiceError: Error {
    case creationFailed
    case updateFailed(ReminderItem)
    case deletionFailed(ReminderItem)
    case toggleFailed(ReminderItem)
}


struct RealmDataProvider: DataProvider {
    
    init() throws {
        
        let realm = try Realm()
        if realm.objects(CategoryItem.self).count == 0 {
            
            CategoryItem.defaultCategoryPairs().forEach { (arg) in
                
                self.createCategory(name: arg.title,
                                    color: arg.color)
            }
        }
    }
    
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    
    //MARK: ReminderServiceType
    @discardableResult
    func createReminder(title: String,
                        category: CategoryItem?,
                        dueDate: Date?) -> Observable<ReminderItem> {
        return Observable.never()
    }
    
    @discardableResult
    func delete(reminder: ReminderItem) -> Observable<Void> {
        return Observable.never()
    }
    
    @discardableResult
    func update(reminder: ReminderItem, toState: ReminderUpdateState) -> Observable<ReminderItem> {
        return Observable.never()
    }
    
    @discardableResult
    func toggle(reminder: ReminderItem) -> Observable<ReminderItem> {
        return Observable.never()
    }
    
    func reminders() -> Observable<Results<ReminderItem>> {
        return Observable.never()
    }
    
    
    //MARK: CategoryServiceType
    @discardableResult
    func createCategory(name: String, color: Color) -> Observable<CategoryItem> {
        
        let result = withRealm("creatingCategory") { realm -> Observable<CategoryItem> in
            
            let category = CategoryItem(name: name,
                                        color: color)
            try realm.write {
                
                category.uid = (realm.objects(CategoryItem.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(category)
            }
            return .just(category)
        }
        return result ?? .error(DataServiceError.creationFailed)
    }
    
    
    @discardableResult
    func changeColor(category: CategoryItem, to newColor: Color) -> Observable<ReminderItem> {
        return Observable.never()
    }
    
    func categories() -> Observable<[Category]> {
        return Observable.never()
    }
    
    
    
}
