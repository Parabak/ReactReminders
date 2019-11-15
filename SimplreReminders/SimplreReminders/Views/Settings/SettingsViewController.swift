//
//  SettingsViewController.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 14/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources


class SettingsViewController: UIViewController {
    
    var toolbarHeight: NSLayoutConstraint?
    let viewModel: SettingsViewModel
    let sortingOptionsControl = UISegmentedControl(items: SortOption.allCases.map{$0.rawValue})
    let tableView = UITableView()
    var addCategory = UIButton()
    var closeBtn = UIButton()
    let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<CategoriesSection>(configureCell: configureCell,
                                                                                            titleForHeaderInSection: configureTitleHeader)
    
    
    init(viewModel: SettingsViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showCloseButton()
        
        NSLayoutConstraint.activate(addOutlets())
        
        bindViewModel()
    }
    
    
    private func bindViewModel() -> Void {
        
        closeBtn.rx.action = self.viewModel.onCancel
        
        viewModel.settings.sortingOption
            .map { SortOption.allCases.firstIndex(of: $0)! }
            .bind(to: sortingOptionsControl.rx.value)
            .disposed(by: disposeBag)
        
        sortingOptionsControl.rx.selectedSegmentIndex.subscribe(onNext: { idx in
            
            guard let title = self.sortingOptionsControl.titleForSegment(at: idx),
                let option = SortOption(rawValue: title) else {
                return
            }
            self.viewModel.settings.changeSortOption(to: option)
            })
        .disposed(by: disposeBag)
        
        viewModel.sectionCategories
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        addCategory.rx.action = viewModel.onAddCategory()
    }
    
    
    private func addOutlets() -> [NSLayoutConstraint] {
        
        let hint = UILabel()
        hint.text = "Define how reminders should be ordered:"
        
        tableView.register(CategoryTableCell.self,
                           forCellReuseIdentifier: "CategoryTableCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        addCategory.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        addCategory.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let toolBar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 15
        toolBar.items = [space, UIBarButtonItem(customView: addCategory)]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(hint)
        stackView.setCustomSpacing(10, after: hint)
        stackView.addArrangedSubview(sortingOptionsControl)
        stackView.setCustomSpacing(20, after: sortingOptionsControl)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(toolBar)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        toolbarHeight = toolBar.heightAnchor.constraint(equalToConstant: 30 + view.safeAreaInsets.bottom)
        return [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbarHeight!
        ]
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        toolbarHeight?.constant = 30 + view.safeAreaInsets.bottom
        view.setNeedsLayout()
    }
    
    private func showCloseButton() -> Void {
        
        closeBtn.setImage(UIImage(systemName: "xmark"),
                          for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }
    
    
    private var configureCell: TableViewSectionedDataSource<CategoriesSection>.ConfigureCell {
        
        return { dataSource, tableView, indexPath, category in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell")
            if let categoryCell = cell as? CategoryTableCell {
                
                categoryCell.configure(with: category)
            }
            
            return cell ?? UITableViewCell()
        }
    }
    
    
    private var configureTitleHeader: TableViewSectionedDataSource<CategoriesSection>.TitleForHeaderInSection {
        return { _, _ in
            return "Categories"
        }
    }
}
