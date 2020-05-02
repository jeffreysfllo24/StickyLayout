//
//  StickyLayout.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-04-29.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

open class StickyLayout: UICollectionViewFlowLayout {
    
    private let stickyConfig: StickyLayoutConfig
    private var cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()

    private var rows: Int {
        return collectionView?.numberOfSections ?? 0
    }

    private func colsCount(section: Int) -> Int {
        return collectionView?.numberOfItems(inSection: section) ?? 0
    }
    
    public init(stickyConfig: StickyLayoutConfig) {
        self.stickyConfig = stickyConfig
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepare() {
        super.prepare()
        layoutCellPositions()
        updateStickyCellPositions()
    }
    
    private func layoutCellPositions() {
        
        guard let collectionView = collectionView, rows > 0 else {
            return
        }

        cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
        
    }
    
    private func stickyCellsTotalHeight(col: Int) -> CGFloat {
        var stickyRowsHeight: CGFloat = 0
        let bottomStickyRowsSet = stickyConfig.getBottomStickyRows(rowCount: rows)
        for section in bottomStickyRowsSet {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0 else { continue }
            let cellSize = getCellSize(forRow: section, forCol: col)
            
            // TODO: May need to remove spacing for last row
            // Efficiency by assuming all rows have the same height?
            let cellSpacing = getCellSpacing(forRow: section)
            stickyRowsHeight += cellSize.height + cellSpacing
        }
        return stickyRowsHeight
    }
    
    private func updateStickyCellPositions() {
         
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
        for (_, attribute) in cellAttrsDict {
            if rect.intersects(attribute.frame) {
                collectionViewAttributes.append(attribute)
            }
        }
        return collectionViewAttributes
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDict[indexPath]
    }
    
    private func getCellSize(forRow row: Int, forCol col: Int) -> CGSize {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath(item: col, section: row)) else {
                return self.itemSize
        }
        return size
    }
    
    private func getCellSpacing(forRow row: Int) -> CGFloat {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let spacing = delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: row) else {
                return self.minimumLineSpacing
        }
        return spacing
    }

}

// MARK: - Sticky Layout Configuration
extension StickyLayout {

    public struct StickyLayoutConfig {

        private let stickyRowsFromTop: Int
        private let stickyRowsFromBottom: Int
        private let stickyColsFromLeft: Int
        private let stickyColsFromRight: Int

        public init(stickyRowsFromTop: Int = 1,
                    stickyRowsFromBottom: Int = 0,
                    stickyColsFromLeft: Int = 1,
                    stickyColsFromRight: Int = 0) {

            self.stickyRowsFromTop = stickyRowsFromTop
            self.stickyRowsFromBottom = stickyRowsFromBottom
            self.stickyColsFromLeft = stickyColsFromLeft
            self.stickyColsFromRight = stickyColsFromRight
        }

        public func getStickyRows(rowCount: Int) -> Set<Int> {
            return getTopStickyRows(rowCount: rowCount).union(getBottomStickyRows(rowCount: rowCount))
        }

        public func getStickyCols(colCount: Int) -> Set<Int> {
            return getLeftStickyCols(colCount: colCount).union(getRightStickyCols(colCount: colCount))
        }

        public func getLeftStickyCols(colCount: Int) -> Set<Int> {
            return getStickySet(totalLength: colCount, startIndex: 0, stickyCount: stickyColsFromLeft)
        }

        public func getRightStickyCols(colCount: Int) -> Set<Int> {
            return getStickySet(totalLength: colCount, startIndex: colCount - stickyColsFromRight, stickyCount: stickyColsFromRight)
        }

        public func getBottomStickyRows(rowCount: Int) -> Set<Int> {
            return getStickySet(totalLength: rowCount, startIndex: rowCount - stickyRowsFromBottom, stickyCount: stickyRowsFromBottom)
        }

        public func getTopStickyRows(rowCount: Int) -> Set<Int> {
            return getStickySet(totalLength: rowCount, startIndex: 0, stickyCount: stickyRowsFromTop)
        }

        private func getStickySet(totalLength: Int, startIndex: Int, stickyCount: Int) -> Set<Int> {
            let stickySetCount = min(totalLength, stickyCount)
            let startIndex = max(startIndex, 0)
            return stickySetCount > 0 ? Set<Int>(startIndex...startIndex + stickySetCount - 1) : Set()
        }
    }
}

// MARK: - ZOrdering
extension StickyLayout {

    private func zOrder(forRow row: Int, forCol col: Int, stickyRowSet: Set<Int>, stickColSet: Set<Int>) -> Int {
        if stickyRowSet.contains(row) && stickColSet.contains(col) {
            return ZOrder.staticCell
        } else if stickyRowSet.contains(row) || stickColSet.contains(col) {
            return ZOrder.stickyCell
        } else {
            return ZOrder.basicCell
        }
    }

    private enum ZOrder {
        static let basicCell = 0
        static let stickyCell = 1
        static let staticCell = 2
    }
}
