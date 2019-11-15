//
//  CategoryTableCell.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 14/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class CategoryTableCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    private let stackView = UIStackView()
    private var nameLbl = UILabel()
    private var colorPreview = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        wrapOutletsInStackView()
        styleOutlets()
    
        NSLayoutConstraint.activate(setupConstraints())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override var reuseIdentifier: String? {
        return "CategoryTableCell"
    }
    
    
    func configure(with category: CategoryItem) -> Void {
        
        category.rx
            .observe(String.self, "name")
            .subscribe(onNext: { [weak self] name in
                self?.nameLbl.text = name
            })
            .disposed(by: disposeBag)
        
        category.rx
            .observe(String.self, "colorName")
            .subscribe(onNext: { [weak self] colorName in

                guard let name = colorName, let color = Color(rawValue: name) else {
                    self?.colorPreview.backgroundColor = Color.black.createUIColor()
                    return
                }
                self?.colorPreview.backgroundColor = color.createUIColor()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func wrapOutletsInStackView() -> (Void) {

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.addArrangedSubview(colorPreview)
        stackView.addArrangedSubview(nameLbl)
        
        addSubview(stackView)
    }
    
    
    private func styleOutlets() -> Void {
        
        nameLbl.font = UIFont.systemFont(ofSize: 14)
        nameLbl.textColor = UIColor.darkText
        colorPreview.layer.cornerRadius = 15.0
    }
    
    private func setupConstraints() -> [NSLayoutConstraint] {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        bottom.priority = UILayoutPriority(999)
        
        return [
            colorPreview.widthAnchor.constraint(equalToConstant: 30),
            colorPreview.heightAnchor.constraint(equalToConstant: 30),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bottom
        ]
    }
}

