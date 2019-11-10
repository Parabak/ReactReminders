//
//  RemindersViewController.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 09/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class RemindersViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private(set) var viewModel: RemindersViewModel
    
    
    init(viewModel: RemindersViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.configure(viewModel: self.viewModel)
    }
    
    
    func configure(viewModel: RemindersViewModel) {

        // bind model rx.ViewDidLoad
    }
}
