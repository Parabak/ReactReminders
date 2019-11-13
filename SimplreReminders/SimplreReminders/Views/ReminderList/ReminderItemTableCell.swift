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

    override func awakeFromNib() {

        super.awakeFromNib()
        
        wrapOutletsInStackView()
        styleOutlets()
        
        if manualConstraints.isEmpty {
            manualConstraints.append(contentsOf: setupConstraints())
            NSLayoutConstraint.activate(manualConstraints)
        }
    }
    

    override var reuseIdentifier: String? {
        return "ReminderItemTableCell"
    }
    
    
    func configure(with item: ReminderItem, toggleAction: CocoaAction) -> Void {
        
        toggleBtn.rx.action = toggleAction
        
        item.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
                self?.titleLbl.text = title
            })
            .disposed(by: disposeBag)
                
        Observable.combineLatest(item.rx.observe(CategoryItem.self, "category"), item.rx.observe(Bool.self, "isDone"))
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
        
        item.rx.observe(Date.self, "dueDate")
            .subscribe(onNext: { [weak self] date in
                self?.dueDateLbl.text = date?.relativeFormat()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: Private
    private func setupConstraints() -> [NSLayoutConstraint] {
        
        return [
            toggleBtn.widthAnchor.constraint(equalToConstant: 15),
            toggleBtn.heightAnchor.constraint(equalToConstant: 15),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ]
    }
    
    
    private func wrapOutletsInStackView() -> Void {
    
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 0
        textStack.addArrangedSubview(titleLbl)
        textStack.addArrangedSubview(categoryLbl)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(toggleBtn)
        stackView.addArrangedSubview(textStack)
        textStack.addArrangedSubview(dueDateLbl)
    }
    
    
    private func styleOutlets() -> Void {
        
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        categoryLbl.font = UIFont.systemFont(ofSize: 12)
        dueDateLbl.font = UIFont.systemFont(ofSize: 10)
        dueDateLbl.textColor = UIColor.lightText
    }
}
