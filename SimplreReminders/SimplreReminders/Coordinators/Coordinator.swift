//
//  Coordinator.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 09/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation


protocol Coordinator {
    
    var coordinators: [Coordinator] { get set }
    
    func start()
}
