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
                        dueDate: Date) -> Observable<ReminderItem> {
        let result = withRealm("creatingReminder") { realm -> Observable<ReminderItem> in
            
            let reminder = ReminderItem(title: title, dueDate: dueDate, category: category)
            try realm.write {
                reminder.uid = (realm.objects(ReminderItem.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(reminder)
            }
            return .just(reminder)
        }
        return result ?? .error(DataServiceError.creationFailed)
    }
    
    
    @discardableResult
    func delete(reminder: ReminderItem) -> Observable<Void> {
        
        let result = withRealm("DeletingItem") { realm -> Observable<Void> in
            
            try realm.write {
                realm.delete(reminder)
            }
            return .empty()
        }
        return result ?? .error(DataServiceError.deletionFailed(reminder))
    }
    
    
    @discardableResult
    func update(reminder: ReminderItem, toState: ReminderUpdateState) -> Observable<ReminderItem> {
        
        let result = withRealm("UpdatingItem") { (realm) -> Observable<ReminderItem> in
            
            try realm.write {
                reminder.title = toState.title
                reminder.category = toState.category
                reminder.dueDate = toState.date
            }
            
            return .just(reminder)
        }
        
        return result ?? .error(DataServiceError.updateFailed(reminder))
    }
    
    
    @discardableResult
    func toggle(reminder: ReminderItem) -> Observable<ReminderItem> {
        
        let result = withRealm("ToggleItem") { realm -> Observable<ReminderItem> in
            
            try realm.write {
                reminder.isDone.toggle()
            }
            return .just(reminder)
        }
        
        return result ?? .error(DataServiceError.toggleFailed(reminder))
    }
    
    
    func reminders() -> Observable<Results<ReminderItem>> {
        
        let result = withRealm("ReadingReminders") { (realm) -> Observable<Results<ReminderItem>> in
            
            let reminders = realm.objects(ReminderItem.self)
            return Observable.collection(from: reminders)
        }
        return result ?? .empty()
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
        assertionFailure("not implemented yet")
        return Observable.never()
    }
    
    
    func categories() -> Observable<Results<CategoryItem>> {
        
        let result = withRealm("Read Categories") { realm -> Observable<Results<CategoryItem>> in
            
            let objects = realm.objects(CategoryItem.self)
            return Observable.collection(from: objects)
        }
        
        return result ?? .empty()
    }
    
    
    
}
