//
//  EditCategoryViewController.swift
//  SimplreReminders
//
//  Created by Aliaksandr Baranouski on 15/11/2019.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources


final class EditCategoryViewController: BaseViewController<EditCategoryViewModel> {
    
    let saveBtn = UIButton(type: .system)
    let nameTxt = UITextField()
    let disposeBag = DisposeBag()
    private lazy var colorsCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    private var flowLayout: UICollectionViewFlowLayout {
  
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 4, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        
        return layout
    }
    
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Color>>(
        configureCell: { (_, collectionView, indexPath, color: Color) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell",
                                                                for: indexPath) as? ColorCollectionCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: color)
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
                cell.makeSolid()
            }
            
            return cell
        }
    )
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
                        
        // Style cell
        // save new caetgory
        styleOutlets()
        NSLayoutConstraint.activate(showOutlets())
        
        bindViewModel()
    }
    
    
    func bindViewModel() {
        
        nameTxt.isEnabled = (viewModel.category?.name ?? "").isEmpty
        nameTxt.text = viewModel.category?.name
        
        viewModel.sectionedColors
            .bind(to: colorsCollection.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        colorsCollection.rx.itemSelected
            .subscribe(onNext: { [weak self] idx in
                
                let cell = self?.colorsCollection.cellForItem(at: idx) as? ColorCollectionCell
                cell?.makeSolid()
            })
            .disposed(by: disposeBag)
        
        colorsCollection.rx.itemDeselected
            .subscribe(onNext: { [weak self] idx in
                let cell = self?.colorsCollection.cellForItem(at: idx) as? ColorCollectionCell
                cell?.makeEmpty()
            })
            .disposed(by: disposeBag)

        let color = Color(rawValue: viewModel.category?.colorName ?? "") ?? Color.black
        let itemIdx = Color.allCases.firstIndex(of: color) ?? 0
        selectColor(at: IndexPath(item: itemIdx, section: 0))
        
        nameTxt.rx.text
            .asObservable()
            .map { !($0 ?? "").isEmpty }
            .bind(to: saveBtn.rx.isEnabled)
            .disposed(by: disposeBag)

        let state = Observable.combineLatest(nameTxt.rx.text.orEmpty, colorsCollection.rx.modelSelected(Color.self))
        saveBtn.rx.tap
            .withLatestFrom(state)
            .filter { !$0.0.isEmpty }.map( { CategoryState($0.0, $0.1) })
            .subscribe(viewModel.onUpdate.inputs)
            .disposed(by: disposeBag)
    }
    
    
    private func selectColor(at idxPath: IndexPath) -> Void {
        
        colorsCollection.selectItem(at: idxPath, animated: true, scrollPosition: .centeredVertically)
        colorsCollection.delegate?.collectionView?(colorsCollection, didSelectItemAt: idxPath)
    }
    
    
    private func showOutlets() -> [NSLayoutConstraint] {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        let hintLbl = UILabel()
        hintLbl.text = "Select color"
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameTxt)
        stackView.setCustomSpacing(20, after: nameTxt)
        stackView.addArrangedSubview(hintLbl)
        stackView.setCustomSpacing(10, after: hintLbl)
        stackView.addArrangedSubview(colorsCollection)
        
        view.addSubview(stackView)
                
        return [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorsCollection.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ]
    }
    
    
    private func styleOutlets() {
        
        colorsCollection.register(ColorCollectionCell.self,
                                  forCellWithReuseIdentifier: "ColorCell")
        colorsCollection.allowsMultipleSelection = false
        
        saveBtn.setTitle("OK", for: .normal)
        nameTxt.borderStyle = .none
        nameTxt.placeholder = "Enter name..."
        colorsCollection.backgroundColor = UIColor.clear
    }
}
