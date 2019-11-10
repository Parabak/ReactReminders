//
//  EditReminderViewController.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 10/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class EditReminderViewController: UIViewController, BindableType {
    
    typealias ViewModelType = EditReminderViewModel
    
    let closeBtn = UIButton(type: .close)
    
    var viewModel: EditReminderViewModel
    
    private let disposeBag = DisposeBag()
    
    
    init(viewModel: EditReminderViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bindViewModel() {
        
        // here bing status to outlets
//        closeBtn.rx.tap.withLatestFrom(<#T##second: ObservableConvertibleType##ObservableConvertibleType#>)
        
        // merge observable of textview with datePicker and categoryPicker
    }
    
    
    
    
}
