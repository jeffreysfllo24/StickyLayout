//
//  StickyLayoutConfig.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-14.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation

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
