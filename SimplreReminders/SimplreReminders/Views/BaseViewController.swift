//
//  BaseViewController.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 17/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit


class BaseViewController<T: ViewModelType>: UIViewController {
        
    var viewModel: T
    
    init(viewModel: T) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.viewModel.title
    }
}
