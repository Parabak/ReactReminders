//
//  Color.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit


enum Color: String {
    case black
    case blue
    case yeallow
    case magenta
    case orange
    case brown
    case purple
    case red
    case green
    
    
    func createUIColor() -> UIColor {
        
        var color: UIColor
        switch self {
        case .black:
            color = UIColor.black
        case .blue:
            color = UIColor.blue
        case .yeallow:
            color = UIColor.yellow
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
        @unknown default:
            color = UIColor.clear
        }
        
        return color
    }
}



