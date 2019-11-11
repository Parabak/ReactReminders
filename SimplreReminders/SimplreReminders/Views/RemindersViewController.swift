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
import Action


class RemindersViewController: UIViewController, BindableType {

    typealias ViewModelType = RemindersViewModel

    var viewModel: RemindersViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: RemindersViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.showAddReminderNavButton()
    }
    
    
    func bindViewModel() -> Void {
        
        // here display all reminders in the list
    }
    
    
    //MARK: Private - Setup UI
    private func showAddReminderNavButton() {
    
        var btn = UIButton(type: .contactAdd)
        btn.rx.action = viewModel.onAddReminder()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btn)]
    }
}
