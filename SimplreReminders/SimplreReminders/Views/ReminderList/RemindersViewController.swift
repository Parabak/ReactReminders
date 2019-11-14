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
                                                                                          titleForHeaderInSection: configureTitleForHeader,
                                                                                          canEditRowAtIndexPath: canEditRowAtIndexPath)
    
    
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
    
        var btnAdd = UIButton(type: .contactAdd)
        btnAdd.rx.action = viewModel.onAddReminder()
        
        var btnSettings = UIButton(type: .custom)
        btnSettings.setImage(UIImage(systemName: "gear"), for: .normal)
        btnSettings.rx.action = viewModel.onOpenSettings()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnAdd),
                                                   UIBarButtonItem(customView: btnSettings),]
    }
    
    
    private func addTableView() -> [NSLayoutConstraint] {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ReminderItemTableCell.self,
                           forCellReuseIdentifier: "ReminderItemTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        
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
        
        tableView.rx.itemSelected.map { indexPath -> ReminderItem in
            return try! self.dataSource.model(at: indexPath) as! ReminderItem
        }
        .subscribe(viewModel.selectReminder.inputs)
        .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.map { [unowned self] indexPath -> ReminderItem? in
            
            return try? self.dataSource.model(at: indexPath) as? ReminderItem
        }
        .subscribe(onNext: { [weak self]  reminder in
            guard let reminder = reminder else { return }
            self?.viewModel.delete(item: reminder)
        })
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
    
    private var canEditRowAtIndexPath: TableViewSectionedDataSource<ReminderSection>.CanEditRowAtIndexPath {
        
        return { dataSource, index in
            return true
        }
    }
}
