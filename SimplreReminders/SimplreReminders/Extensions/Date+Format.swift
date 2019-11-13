//
//  Date+Format.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 13/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation


extension Date {

    
    /// Use DateFormatter to convert Date instance to String form considering date's relation to `today`.
    func relativeFormat() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        
        return formatter.string(from: self)
    }
}

