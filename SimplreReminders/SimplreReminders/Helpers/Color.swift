//
//  Color.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources


enum Color: String, CaseIterable {
    case gray
    case blue
    case cyan
    case magenta
    case orange
    case brown
    case red
    case green
    case purple
    
    
    func createUIColor() -> UIColor {
        
        var color: UIColor
        switch self {
        case .gray:
            color = UIColor.gray
        case .blue:
            color = UIColor.blue
        case .cyan:
            color = UIColor.cyan
        case .magenta:
            color = UIColor.magenta
        case .orange:
            color = UIColor.orange
        case .brown:
            color = UIColor.brown
        case .purple:
            color = UIColor.purple
        case .red:
            color = UIColor.red
        case .green:
            color = UIColor.green
        }
        
        return color
    }
}


extension Color: IdentifiableType {
    

    var identity: String {
        return rawValue
    }
}
