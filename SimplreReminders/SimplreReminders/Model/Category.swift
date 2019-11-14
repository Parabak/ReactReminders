//
//  Category.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources


class CategoryItem: Object {
    
    @objc dynamic var uid: Int = 0
    @objc dynamic var colorName: String = ""
    @objc dynamic var name: String = ""
    
    @objc override class func primaryKey() -> String? {
        return "uid"
    }
    
    convenience init(name: String, color: Color) {
        
        self.init()
        self.name = name
        self.colorName = color.rawValue
    }
    
    typealias CategoryInitializer = (title: String, color: Color)
    static func defaultCategoryPairs() -> [CategoryInitializer] {
        
        return [("Important", Color.red),
                ("Cars", Color.magenta),
                ("Family", Color.purple),
                ("Long-term", Color.green)]
    }
}


extension CategoryItem: IdentifiableType {
    
    var identity: Int {
        return isInvalidated ? 0 : uid
    }
}
