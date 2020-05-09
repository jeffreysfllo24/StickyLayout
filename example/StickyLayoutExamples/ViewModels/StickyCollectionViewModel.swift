//
//  StickyCollectionViewModel.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-05.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import StickyLayout

protocol StickyCollectionViewModel {
    //Sticky Configuration
    var stickyConfig: StickyLayoutConfig { get }
    
    // Dimensions
    var rowCount: Int { get }
    func colCount(forRow row: Int) -> Int
    
    // Style
    func backgroundColor() -> UIColor
    
    // Spacing
    func interItemSpacing() -> CGFloat
    func sectionSpacing() -> CGFloat
    
    // Sizing
    func getCellSize(indexPath: IndexPath) -> CGSize
    
    // Cell
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell
    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell)
}
