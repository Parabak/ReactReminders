//
//  ReminderItemTableCell.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 13/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Action


class ReminderItemTableCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    private let stackView = UIStackView()
    private var titleLbl = UILabel()
    private var categoryLbl = UILabel()
    private var dueDateLbl = UILabel()
    private var toggleBtn = UIButton()
    
//    ✅✔️
    private var manualConstraints = [NSLayoutConstraint]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        wrapOutletsInStackView()
        styleOutlets()
        
        if manualConstraints.isEmpty {
            manualConstraints.append(contentsOf: setupConstraints())
            NSLayoutConstraint.activate(manualConstraints)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override var reuseIdentifier: String? {
        return "ReminderItemTableCell"
    }
    
    
    func configure(with item: ReminderItem, toggleAction: CocoaAction) -> Void {
        
        toggleBtn.rx.action = toggleAction
        
        item.rx
            .observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
                self?.titleLbl.text = title
            })
            .disposed(by: disposeBag)
                
        Observable.combineLatest(item.rx.observe(CategoryItem.self, "category"),
                                 item.rx.observe(Bool.self, "isDone"))
            .subscribe(onNext: { [weak self] arg in
            
                let (category, isDone) = arg
                self?.categoryLbl.text = category?.name
                let colorName = category?.colorName ?? Color.black.rawValue
                let color = Color(rawValue: colorName)?.createUIColor() ?? UIColor.black
                
                self?.categoryLbl.textColor = color
                self?.toggleBtn.layer.borderColor = color.cgColor
                self?.toggleBtn.layer.borderWidth = 1
                self?.toggleBtn.backgroundColor = (isDone ?? false) ? color : UIColor.clear
            })
            .disposed(by: disposeBag)
        
        item.rx
            .observe(Date.self, "dueDate")
            .subscribe(onNext: { [weak self] date in
                self?.dueDateLbl.text = date?.relativeFormat()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: Private
    private func setupConstraints() -> [NSLayoutConstraint] {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        bottom.priority = UILayoutPriority(999)
        
        return [
            toggleBtn.widthAnchor.constraint(equalToConstant: 30),
            toggleBtn.heightAnchor.constraint(equalToConstant: 30),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bottom
        ]
    }
    
    
    private func wrapOutletsInStackView() -> Void {
    
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.addArrangedSubview(titleLbl)
        textStack.addArrangedSubview(dueDateLbl)

        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(toggleBtn)
        stackView.addArrangedSubview(textStack)
        stackView.addArrangedSubview(categoryLbl)
        
        addSubview(stackView)
    }
    
    
    private func styleOutlets() -> Void {
        
        titleLbl.font = UIFont.systemFont(ofSize: 18)
        titleLbl.numberOfLines = 2
        categoryLbl.font = UIFont.systemFont(ofSize: 15)
        dueDateLbl.font = UIFont.systemFont(ofSize: 14)
        dueDateLbl.textColor = UIColor.darkText        
        toggleBtn.layer.cornerRadius = 15.0
    }
}
