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
import RxCocoa


class RemindersViewController: UIViewController, BindableType {

    typealias ViewModelType = RemindersViewModel

    var viewModel: RemindersViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: RemindersViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.showAddReminderNavButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bindViewModel() {
        
        
    }
    
    
    //MARK: Private - Setup UI
    private func showAddReminderNavButton() {
    
        let btn = UIButton(type: .contactAdd)
//        btn.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
    }
}
