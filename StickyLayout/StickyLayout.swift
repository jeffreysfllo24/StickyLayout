//
//  StickyLayout.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-06.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

open class StickyLayout: UICollectionViewFlowLayout {
    private let stickyConfig: StickyLayoutConfig
    private var cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellFramesDict = [IndexPath: CGRect]()
    private var collectionViewContentWidth: CGFloat = 0
    private var collectionViewContentHeight: CGFloat = 0
    
    override open var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewContentWidth, height: collectionViewContentHeight)
    }
    
    private var rows: Int {
        return collectionView?.numberOfSections ?? 0
    }

    private func colsCount(section: Int) -> Int {
        return collectionView?.numberOfItems(inSection: section) ?? 0
    }
    
    public init(stickyConfig: StickyLayoutConfig = StickyLayoutConfig()) {
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
        
        // Reset collection view attributes for new layout
        cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
        cellFramesDict = [IndexPath: CGRect]()
        collectionViewContentWidth = 0
        collectionViewContentHeight = 0
        
        // Set Containing current xPos and current yPos for each column
        var xPos: CGFloat = 0
        var yPos: CGFloat = 0
        
        let bottomStickyRowsSets = stickyConfig.getBottomStickyRows(rowCount: rows)
        
        // Retrieve height of right sticky columns and bottom sticky rows
        var stickyColHeights = stickyCellHeights()
        var stickyRowWidths = stickyCellsRowWidths()
        
        for section in 0..<rows {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            let rightStickyColsSets = stickyConfig.getRightStickyCols(colCount: itemsCount)
            let sectionSpacing = (section == rows - 1) ? 0 : getSectionSpacing(forRow: section)
            let interItemSpacing = getInterItemSpacing(forRow: section)
            var maxCellHeightForSection: CGFloat = 0

            for item in 0..<itemsCount {
                let cellSize = getCellSize(forRow: section, forCol: item)
                let cellWidth = cellSize.width
                let cellHeight = cellSize.height
                let cellIndex = IndexPath(item: item, section: section)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                let interItemSpacing = (item == itemsCount - 1) ? 0 : interItemSpacing
                maxCellHeightForSection = max(maxCellHeightForSection, cellHeight)

                var stickyRowYPos = yPos
                if bottomStickyRowsSets.contains(section) {
                    stickyRowYPos = collectionView.frame.height - stickyColHeights

                    if yPos < stickyRowYPos {
                        stickyRowYPos = yPos
                    }
                }
                
                var stickyRowXPos = xPos
                if rightStickyColsSets.contains(item) {
                    stickyRowXPos = collectionView.frame.width - (stickyRowWidths[section] ?? 0)
                
                    if xPos < stickyRowXPos {
                        stickyRowXPos = xPos
                    }
    
                    stickyRowWidths[section] = (stickyRowWidths[section] ?? 0) - cellWidth - interItemSpacing
                }
                
                cellFramesDict[cellIndex] = CGRect(x: stickyRowXPos, y: stickyRowYPos, width: cellWidth, height: cellHeight)
                cellAttributes.frame = cellFramesDict[cellIndex] ?? .zero
                cellAttrsDict[cellIndex] = cellAttributes
                xPos += cellWidth + interItemSpacing
            }
            
            if bottomStickyRowsSets.contains(section) {
                stickyColHeights -= (maxCellHeightForSection + sectionSpacing)
            }
            
            yPos += maxCellHeightForSection + sectionSpacing
            collectionViewContentWidth = max(collectionViewContentWidth, xPos)
            xPos = 0
        }
        collectionViewContentHeight = yPos
    }
    
    private func stickyCellHeights() -> CGFloat {
        var stickyCellHeights: CGFloat = 0
        
        let bottomStickyRowsSet = stickyConfig.getBottomStickyRows(rowCount: rows)
        for section in bottomStickyRowsSet {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0 else { continue }
            let cellSpacing = (section == rows - 1) ? 0 : getSectionSpacing(forRow: section)
            var maximumCellRowHeight: CGFloat = 0
            for col in 0..<itemsCount {
                let cellSize = getCellSize(forRow: section, forCol: col)
                maximumCellRowHeight = max(maximumCellRowHeight, cellSize.height)
            }
            stickyCellHeights += maximumCellRowHeight + cellSpacing
        }
        return stickyCellHeights
    }
    
    private func stickyCellsRowWidths() -> [Int: CGFloat] {
        var stickyRowWidths: [Int: CGFloat] = [:]
        
        for section in 0..<rows {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0, !stickyConfig.getRightStickyCols(colCount: itemsCount).isEmpty else {
                continue
            }

            let stickyCols = stickyConfig.getRightStickyCols(colCount: itemsCount)
            let cellSpacing = getInterItemSpacing(forRow: section)

            for col in stickyCols {
                let cellSize = getCellSize(forRow: section, forCol: col)
                let cellSpacing = (col == itemsCount - 1) ? 0 : cellSpacing
                stickyRowWidths[section] = (stickyRowWidths[section] ?? 0) + cellSize.width + cellSpacing
            }
        }

        return stickyRowWidths
    }
    
    private func updateStickyCellPositions() {
        guard let collectionView = collectionView else {
             return
         }
         
        let stickyRowSet = stickyConfig.getStickyRows(rowCount: rows)

        for row in 0..<rows {
            let itemCount = collectionView.numberOfItems(inSection: row)
            let stickyColSet = stickyConfig.getStickyCols(colCount: itemCount)
            // Check if the row is sticky and if there are sticky columns in the row
            guard stickyRowSet.contains(row) || !stickyColSet.isEmpty else {
                return
            }

            for col in 0..<itemCount {
                let cellIndex = IndexPath(item: col, section: row)
                let attribute = cellAttrsDict[cellIndex]
                 
                if stickyRowSet.contains(row) {
                    attribute?.frame.origin.y = (cellFramesDict[cellIndex]?.origin.y ?? 0) + collectionView.contentOffset.y
                }
                 
                if stickyColSet.contains(col) {
                    attribute?.frame.origin.x = (cellFramesDict[cellIndex]?.origin.x ?? 0) + collectionView.contentOffset.x
                }
                attribute?.zIndex = zOrder(forRow: row, forCol: col, stickyRowSet: stickyRowSet, stickyColSet: stickyColSet)
             }
        }
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
        for (index, attribute) in cellAttrsDict {
            /// Unique case where we need to add right sticky column because collection view bounds don't update when you horizontally force scroll out of collection view content size.
            if stickyConfig.getRightStickyCols(colCount: colsCount(section: index.section)).contains(index.item) {
                collectionViewAttributes.append(attribute)
            } else if rect.intersects(attribute.frame) {
                collectionViewAttributes.append(attribute)
            }
        }
        return collectionViewAttributes
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
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
    
    private func getSectionSpacing(forRow row: Int) -> CGFloat {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let spacing = delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: row) else {
                return self.minimumLineSpacing
        }
        return spacing
    }
    
    private func getInterItemSpacing(forRow row: Int) -> CGFloat {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let spacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: row) else {
                return self.minimumInteritemSpacing
        }
        return spacing
    }

}

// MARK: - ZOrdering
extension StickyLayout {

    private func zOrder(forRow row: Int, forCol col: Int, stickyRowSet: Set<Int>, stickyColSet: Set<Int>) -> Int {
        if stickyRowSet.contains(row) && stickyColSet.contains(col) {
            return ZOrder.staticCell
        } else if stickyRowSet.contains(row) || stickyColSet.contains(col) {
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
