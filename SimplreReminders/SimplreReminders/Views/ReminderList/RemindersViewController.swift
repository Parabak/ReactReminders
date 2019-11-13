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
import RxDataSources


class RemindersViewController: UIViewController {
    
    var viewModel: RemindersViewModel
    
    private(set) var tableView = UITableView()
    private let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<ReminderSection>(configureCell: configureCell,
                                                                                          titleForHeaderInSection: configureTitleForHeader)
    
    
    init(viewModel: RemindersViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        bindViewModel()
        
        self.showAddReminderNavButton()
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: addTableView())
        NSLayoutConstraint.activate(constraints)
    }
    
        
    //MARK: Private - Setup UI
    private func showAddReminderNavButton() -> Void {
    
        var btn = UIButton(type: .contactAdd)
        btn.rx.action = viewModel.onAddReminder()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btn)]
    }
    
    
    private func addTableView() -> [NSLayoutConstraint] {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ReminderItemTableCell.self,
                           forCellReuseIdentifier: "ReminderItemTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        self.view.addSubview(tableView)
        return [
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    
    // MARK: Private
    private func bindViewModel() -> Void {
        
        viewModel.sectionedReminders.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    
    private var configureCell : TableViewSectionedDataSource<ReminderSection>.ConfigureCell {
        
        return { [weak self] dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderItemTableCell",
                                                     for: indexPath) as! ReminderItemTableCell
            if let strongSelf = self {
                
                cell.configure(with: item,
                               toggleAction: strongSelf.viewModel.onToggle(item: item))
            }
            return cell
        }
    }
    
    
    private var configureTitleForHeader : TableViewSectionedDataSource<ReminderSection>.TitleForHeaderInSection {
        return { dataSource, index in
            return dataSource.sectionModels[index].model
        }
    }
}