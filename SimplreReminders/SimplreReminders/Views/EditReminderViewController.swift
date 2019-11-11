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
    let okBtn = UIButton()
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    let titleTxtView = UITextView()
    let datePickerButton = UIButton()
    let categoryPickerButton = UIButton()
    let contentStackView = UIStackView()
    
    let test = UICollectionView()
    
    private let disposeBag = DisposeBag()
    private var datePickerBottomConstraint: NSLayoutConstraint?
    private var categoryPickerBottomConstraint: NSLayoutConstraint?
    
    var viewModel: EditReminderViewModel
    
    
    init(viewModel: EditReminderViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: addContentStackView())
        constraints.append(contentsOf: addDatePicker())
        constraints.append(contentsOf: addCategoryPicker())
        
        NSLayoutConstraint.activate(constraints)
        
        bindTogetherOutlets()
        
        showNavButtons()
    }
    
    private func showNavButtons() {
    
        okBtn.setTitle("OK", for: .normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okBtn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }
    
    
    private func addContentStackView() -> [NSLayoutConstraint] {
     
        let lblHint = UILabel()
        lblHint.text = "Title:"
        
        self.view.addSubview(contentStackView)
        
        contentStackView.spacing = 15
        contentStackView.distribution = .fill
        contentStackView.alignment = .leading
        contentStackView.axis = .horizontal
        
        contentStackView.addArrangedSubview(lblHint)
        contentStackView.addArrangedSubview(titleTxtView)
        contentStackView.addArrangedSubview(categoryPickerButton)
        contentStackView.addArrangedSubview(datePickerButton)
        
        return [
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ]
    }
    
    
    private func addDatePicker() -> [NSLayoutConstraint] {
        
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.date = viewModel.reminderState.date
        
        let bottomConstraint = datePicker.topAnchor.constraint(equalTo: view.bottomAnchor)
        datePickerBottomConstraint = bottomConstraint
        return [
            bottomConstraint,
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15)
        ]
    }
    
    
    private func addCategoryPicker() -> [NSLayoutConstraint] {
     
        view.addSubview(categoryPicker)
        
        if let category = viewModel.reminderState.category {
            
            viewModel.categories.takeLast(1).subscribe(onNext: { [weak self] categories in
                
                if let idx = categories.firstIndex(of: category) {
                    
                    self?.categoryPicker.selectRow(idx, inComponent: 0, animated: false)
                } else {
                    
                    self?.categoryPicker.selectRow(0, inComponent: 0, animated: false)
                }
            })
            .disposed(by: disposeBag)
        } else {
            categoryPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        let bottomConstraint = categoryPicker.topAnchor.constraint(equalTo: view.bottomAnchor)
        categoryPickerBottomConstraint = bottomConstraint
        return [
            bottomConstraint,
            categoryPicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            categoryPicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15)
        ]
    }
    
    
    func bindViewModel() -> Void {
        
        viewModel.categories.bind(to: categoryPicker.rx.itemTitles) { (row, element) in
            return element.name
        }.disposed(by: disposeBag)
        
        let text = closeBtn.rx.tap.withLatestFrom(titleTxtView.rx.text.orEmpty)
        let category = categoryPicker.rx.modelSelected(CategoryItem.self).asObservable()
        let date = datePicker.rx.date.asObservable()
        
        okBtn.rx.tap
            .withLatestFrom(Observable.combineLatest(text, category, date))
            .map { (text, categories, date) -> ReminderUpdateState in
                ReminderUpdateState(title: text, date: date, category: categories.first)
            }.subscribe(viewModel.onUpdate.inputs)
            .disposed(by: disposeBag)
    }
    
    
    private func bindTogetherOutlets() {
        
        categoryPicker.rx.modelSelected(CategoryItem.self).map { items -> NSAttributedString? in
            
            guard let item = items.first else { return nil }
            let color = Color(rawValue: item.colorName) ?? Color.black
            return NSAttributedString(string: item.name, attributes: [.foregroundColor : color,
                                                                      .font : UIFont.systemFont(ofSize: 12)])
        }
        .bind(to: categoryPickerButton.rx.attributedTitle())
        .disposed(by: disposeBag)
    
        
        datePicker.rx.date.asObservable().map { (date) -> String in
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.doesRelativeDateFormatting = true
            
            return formatter.string(from: date)
        }
        .bind(to: datePickerButton.rx.title())
        .disposed(by: disposeBag)
        
        //TODO: try to avoid duplicating logic between these two observables
        categoryPickerButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
          
                UIView.animate(withDuration: 0.3) {
                    let isHidden = self?.categoryPickerBottomConstraint?.constant == 0
                    self?.categoryPickerBottomConstraint?.constant = isHidden ? self?.categoryPicker.frame.height ?? 0 : 0
                }
        }).disposed(by: disposeBag)
        
        
        datePickerButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
          
                UIView.animate(withDuration: 0.3) {
                    let isHidden = self?.datePickerBottomConstraint?.constant == 0
                    self?.datePickerBottomConstraint?.constant = isHidden ? self?.datePicker.frame.height ?? 0 : 0
                }
        }).disposed(by: disposeBag)
    }
    
}
