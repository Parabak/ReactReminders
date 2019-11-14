//
//  Settings.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 14/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import RxSwift


enum SortOption: String {
    
    case alphabetical
    case date
}

extension SortOption: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .alphabetical:
            return "Alphabetically"
        case .date:
            return "By due data"
        }
    }
}


struct Settings {
    
    let sortingOption: BehaviorSubject<SortOption>
    
    init() {
        
        let storedValue = (UserDefaults.standard.object(forKey: "sortingOption") as? String) ?? SortOption.alphabetical.rawValue
        let option = SortOption(rawValue: storedValue) ?? .alphabetical
        sortingOption = BehaviorSubject(value: option)
    }
    
    
    mutating func changeSortOption(to option: SortOption) -> Void {
        
        sortingOption.onNext(option)
        UserDefaults.standard.set(option.rawValue, forKey: "sortingOption")
    }
}
