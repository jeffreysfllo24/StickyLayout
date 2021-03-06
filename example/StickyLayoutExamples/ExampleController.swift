//
//  ExampleController.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-02.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit
import StickyLayout

class ExampleStickyController: UIViewController {
    
    let stickyLayoutType: StickyLayoutTypes
    let numberOfItems = 5
    let stickyCollectionViewModel: StickyCollectionViewModel

    init(stickLayoutType: StickyLayoutTypes) {
        stickyLayoutType = stickLayoutType
        switch stickyLayoutType {
        case .calendar:
            self.stickyCollectionViewModel = CalendarViewModel()
        case .tabular:
            self.stickyCollectionViewModel = MobileExpenseViewModel()
        case .horizontal:
            self.stickyCollectionViewModel = SwimLeaderboardViewModel()
        }
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.clipsToBounds = true
        
        let collectionView = createCollectionView()
        view.addSubview(collectionView)
        
        var topSafeAreaHeight: CGFloat = 0
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
          let window = UIApplication.shared.windows[0]
          let safeFrame = window.safeAreaLayoutGuide.layoutFrame
          topSafeAreaHeight = safeFrame.minY
          bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:
                navigationController?.navigationBar.frame.maxY ?? topSafeAreaHeight),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSafeAreaHeight),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
            ])
    }
        
    private func createCollectionView() -> UICollectionView {
        let stickyLayout = StickyLayout(stickyConfig: stickyCollectionViewModel.stickyConfig)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: stickyLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = stickyCollectionViewModel.backgroundColor()
        collectionView.register(LabelCell.self, forCellWithReuseIdentifier: LabelCell.reuseIdentifier)
        return collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExampleStickyController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickyCollectionViewModel.colCount(forRow: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return stickyCollectionViewModel.rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: LabelCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        stickyCollectionViewModel.setCellStyle(collectionView: collectionView, indexPath: indexPath, cell: cell)
    }
}

extension ExampleStickyController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return stickyCollectionViewModel.getCellSize(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return stickyCollectionViewModel.sectionSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return stickyCollectionViewModel.interItemSpacing()
    }
}
