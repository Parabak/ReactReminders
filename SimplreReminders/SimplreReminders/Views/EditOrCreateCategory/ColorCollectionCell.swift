//
//  CategoryCell.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 15/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit


class ColorCollectionCell: UICollectionViewCell {
    
    private let colorIcon = UIView()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        NSLayoutConstraint.activate(showColorIcon())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with color: Color) -> Void {
        
        colorIcon.layer.borderColor = color.createUIColor().cgColor
        makeEmpty()
    }
    
    
    func makeSolid() -> Void {
        colorIcon.layer.backgroundColor = colorIcon.layer.borderColor
    }
    
    func makeEmpty() -> Void {
        colorIcon.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    private func showColorIcon() -> [NSLayoutConstraint] {
        
        colorIcon.layer.borderWidth = 3
        colorIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorIcon)
        
        return [
            colorIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorIcon.heightAnchor.constraint(equalTo: heightAnchor),
            colorIcon.widthAnchor.constraint(equalTo: colorIcon.heightAnchor)
        ]
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        colorIcon.layer.cornerRadius = colorIcon.frame.height / 2
    }
}
