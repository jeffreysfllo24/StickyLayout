//
//  StickyLayout.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-06.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Sticky Layout Configuration
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

open class StickyLayout: UICollectionViewFlowLayout {
    
    private let stickyConfig: StickyLayoutConfig
    private var cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellFramesDict = [IndexPath: CGRect]()
    private var collectionViewContentWidth: CGFloat = 0
    private var collectionViewContentHeight: CGFloat = 0
    private var newBounds: CGRect = .zero
    
    override public var collectionViewContentSize: CGSize {
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
        self.scrollDirection = .horizontal
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
        
        guard let collectionView = collectionView, rows > 0, (cellAttrsDict.isEmpty || !newBounds.size.equalTo(collectionView.bounds.size)) else {
            return
        }

        cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
        
        // Set Containing current xPos and current yPos for each column
        var xPos: CGFloat = 0
        var yPos: CGFloat = 0
        
        let bottomStickyRowsSets = stickyConfig.getBottomStickyRows(rowCount: rows)
        
        // Retrieve height of right sticky columns and bottom sticky rows
        var stickyColHeights = stickCellHeights()
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
                maxCellHeightForSection = max(maxCellHeightForSection, cellHeight)
                let cellIndex = IndexPath(item: item, section: section)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                let interItemSpacing = (item == itemsCount - 1) ? 0 : interItemSpacing
                
                var stickyRowYPos = yPos
                if bottomStickyRowsSets.contains(section) {
                    stickyRowYPos = collectionView.frame.height - stickyColHeights
                    
                    // Check if the current Y position is smaller than where the stickyRow would be when aligned to
                    // the bottom. If true, the tableview height is smaller than the container and we update the
                    // stickyRow Y position with the current Y position.
                    if yPos < stickyRowYPos {
                        stickyRowYPos = yPos
                    }
                }
                
                var stickyRowXPos = xPos
                if rightStickyColsSets.contains(item) {
                    stickyRowXPos = collectionView.frame.width - (stickyRowWidths[section] ?? 0)
                    
                    // Check if the current X position is smaller than where the stickyCol would be when aligned to
                    // the right. If true, the tableview width is smaller than the container and we update the stickyRow
                    // X position with the current X position.
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
    
    private func stickCellHeights() -> CGFloat {
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

    private func stickyCellsColHeights() -> [Int: CGFloat] {
        var stickyColHeights: [Int: CGFloat] = [:]
        
        let bottomStickyRowsSet = stickyConfig.getBottomStickyRows(rowCount: rows)
        for section in bottomStickyRowsSet {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0 else { continue }
            let cellSpacing = (section == rows - 1) ? 0 : getSectionSpacing(forRow: section)

            for col in 0..<itemsCount {
                let cellSize = getCellSize(forRow: section, forCol: col)
                stickyColHeights[col] = (stickyColHeights[col] ?? 0) + cellSize.height + cellSpacing
            }
        }
        return stickyColHeights
    }
    
    private func stickyCellsRowWidths() -> [Int: CGFloat] {
        var stickyRowWidths: [Int: CGFloat] = [:]
        
        for section in 0..<rows {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0 else { continue }
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

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        self.newBounds = newBounds
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
        
        for (index, attribute) in cellAttrsDict {
            if stickyConfig.getRightStickyCols(colCount: colsCount(section: index.section)).contains(index.item) {
                collectionViewAttributes.append(attribute)
            } else if rect.intersects(attribute.frame) {
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
