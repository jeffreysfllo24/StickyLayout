//
//  ExampleController.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-02.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

class ExampleStickyController: UIViewController {
    
    let stickyLayoutType: StickyLayoutTypes
    let numberOfItems = 15
    lazy var stickyLayout = StickyLayout(stickyConfig: StickyLayout.StickyLayoutConfig(stickyRowsFromTop: 2, stickyRowsFromBottom: 2, stickyColsFromLeft: 2, stickyColsFromRight: 2))
    
    init(stickLayoutType: StickyLayoutTypes) {
        stickyLayoutType = stickLayoutType
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.clipsToBounds = true
        
        let collectionView = createCollectionView()
        view.addSubview(collectionView)
        
        collectionView.frame = CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: 375, height: 600)
    }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: stickyLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor()
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        return collectionView
    }
    
    private func backgroundColor() -> UIColor {
        switch stickyLayoutType {
        case .calendar:
            return .blue
        case .tabular:
            return .brown
        case .horizontal:
            return .gray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExampleStickyController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .cyan
        cell.label.text = "\(indexPath.item)"
        cell.layer.cornerRadius = 10
        return cell
    }
    
}

extension ExampleStickyController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
