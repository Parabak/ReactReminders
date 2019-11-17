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


class EditReminderViewController: BaseViewController<EditReminderViewModel> {
    
    private(set) var closeBtn = UIButton(type: .close)
    let okBtn = UIButton(type: .system)
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    let titleTxtView = UITextView()
    let datePickerButton = UIButton()
    let categoryPickerButton = UIButton()
    let contentStackView = UIStackView()
    let notificationSwitcher = UISwitch()
    
    private let disposeBag = DisposeBag()
    private var datePickerBottomConstraint: NSLayoutConstraint?
    private var categoryPickerBottomConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: addContentStackView())
        constraints.append(contentsOf: addDatePicker())
        constraints.append(contentsOf: addCategoryPicker())
        NSLayoutConstraint.activate(constraints)
        
        showNavButtons()
        bindViewModel()
        
        
    }
    
    private func showNavButtons() {
    
        okBtn.setTitle("OK", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okBtn)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }
    
    
    private func addContentStackView() -> [NSLayoutConstraint] {
     
        let lblHint = UILabel()
        lblHint.text = "Title:"
        
        view.addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = 15
        contentStackView.distribution = .fill
        contentStackView.alignment = .leading
        contentStackView.axis = .vertical
        
        contentStackView.addArrangedSubview(lblHint)
        contentStackView.addArrangedSubview(titleTxtView)
        contentStackView.addArrangedSubview(categoryPickerButton)
        contentStackView.addArrangedSubview(datePickerButton)
        contentStackView.addArrangedSubview(wrapNotificationSwitcher())
        
        titleTxtView.layer.borderColor = UIColor.lightGray.cgColor
        titleTxtView.layer.borderWidth = 1
        categoryPickerButton.setTitleColor(UIColor.black, for: .normal)
        datePickerButton.setTitleColor(UIColor.black, for: .normal)
        
        return [
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleTxtView.heightAnchor.constraint(equalToConstant: 100),
            titleTxtView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ]
    }
    
    
    private func wrapNotificationSwitcher() -> UIStackView {
        
        let lblNotificationHint = UILabel()
        lblNotificationHint.text = "Send notification: "
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        
        stackView.addArrangedSubview(lblNotificationHint)
        stackView.addArrangedSubview(notificationSwitcher)
        
        return stackView
    }
    
    
    private func addDatePicker() -> [NSLayoutConstraint] {
        
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = viewModel.reminderState.date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
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
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        let bottomConstraint = categoryPicker.topAnchor.constraint(equalTo: view.bottomAnchor)
        categoryPickerBottomConstraint = bottomConstraint
        return [
            bottomConstraint,
            categoryPicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            categoryPicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15)
        ]
    }
    
    
    func bindViewModel() -> Void {
        
        titleTxtView.text = viewModel.reminderState.title
        
        viewModel.categories.bind(to: categoryPicker.rx.itemTitles) { (row, element) in
            return element.name
        }.disposed(by: disposeBag)
        
        notificationSwitcher.isOn = viewModel.reminderState.hasNotification
        
        let text = titleTxtView.rx.text.orEmpty.asObservable()
        let category = categoryPicker.rx.modelSelected(CategoryItem.self).asObservable().map {$0.first}
        let date = datePicker.rx.date.asObservable()
        let notification = notificationSwitcher.rx.isOn.asObservable()
        
        titleTxtView.rx.text
            .map { !($0 ?? "").isEmpty }
            .bind(to: okBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        okBtn.rx.tap
            .withLatestFrom(Observable.combineLatest(text, category, date, notification))
            .filter{ !$0.0.isEmpty}
            .map { (text, categoryItem, date, notification) -> ReminderUpdateState in
                ReminderUpdateState(title: text, date: date, category: categoryItem, hasNotification: notification)
        }.subscribe(viewModel.onUpdate.inputs)
            .disposed(by: disposeBag)
        
        closeBtn.rx.action = viewModel.onCancel
    
        bindTogetherOutlets()
    }
    
    
    private func selectRowInCategoryPicker(at idx: Int) -> Void {
        
        categoryPicker.selectRow(idx,
                                 inComponent: 0,
                                 animated: false)
        categoryPicker.delegate?.pickerView!(categoryPicker,
                                             didSelectRow: 0,
                                             inComponent: 0)
    }
    
    //TODO: Refactoring. Extract small logic method.
    private func bindTogetherOutlets() {
        
        //TODO: It will be nice to color also lblTitle, border of textview and date button.
        categoryPicker.rx.modelSelected(CategoryItem.self).map { items -> NSAttributedString? in
            
            guard let item = items.first else { return nil }
            let color = Color(rawValue: item.colorName) ?? Color.black
            return NSAttributedString(string: item.name, attributes: [.foregroundColor : color.createUIColor()
                                                                      ])
        }
        .bind(to: categoryPickerButton.rx.attributedTitle())
        .disposed(by: disposeBag)
    
        if let category = viewModel.reminderState.category {
    
            let subject = ReplaySubject<[CategoryItem]>.create(bufferSize: 1)
            _ = viewModel.categories.subscribe(subject)
            subject.subscribe(onNext: { [weak self] categories in
                
                let idx = categories.firstIndex(of: category) ?? 0
                self?.selectRowInCategoryPicker(at: idx)
            })
            .disposed(by: disposeBag)
        } else {
            selectRowInCategoryPicker(at: 0)
        }
        
        
        datePicker.rx.date.asObservable().map { (date) -> String in            
            return date.relativeFormat()
        }
        .bind(to: datePickerButton.rx.title())
        .disposed(by: disposeBag)
        
        
        //TODO: try to avoid duplicating logic between these two observables
        categoryPickerButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
          
                UIView.animate(withDuration: 0.3) {
                    let isHidden = self.categoryPickerBottomConstraint?.constant == 0
                    let constant = isHidden ? -(self.categoryPicker.frame.height + self.view.safeAreaInsets.bottom) : 0
                    self.categoryPickerBottomConstraint?.constant = constant
                    self.datePickerBottomConstraint?.constant = 0
                    self.view.layoutIfNeeded()
                }
        }).disposed(by: disposeBag)
        
        
        datePickerButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
          
                UIView.animate(withDuration: 0.3) {
                    
                    let isHidden = self.datePickerBottomConstraint?.constant == 0
                    let constant = isHidden ? -(self.datePicker.frame.height + self.view.safeAreaInsets.bottom) : 0
                    self.datePickerBottomConstraint?.constant = constant
                    self.categoryPickerBottomConstraint?.constant = 0
                    self.view.layoutIfNeeded()
                }
        }).disposed(by: disposeBag)
        
        
        notificationSwitcher.rx.isOn
            .filter {$0}
            .subscribe(onNext: { [weak self] flag in
            
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
                    
                    DispatchQueue.main.async {
                        self?.notificationSwitcher.isOn = granted
                    }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    //TODO: never called. reference loop
    deinit {
        print("everything is OK, EditReminderViewController is dead")
    }
}
