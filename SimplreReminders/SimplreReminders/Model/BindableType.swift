//
//  BindableType.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit


protocol BindableType {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType { get set }
    
    func bindViewModel()
}


extension BindableType where Self: UIViewController {
    
    mutating func bind(viewModel model: Self.ViewModelType) {
        
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
