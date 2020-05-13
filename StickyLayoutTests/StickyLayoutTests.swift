//
//  StickyLayoutTests.swift
//  StickyLayoutTests
//
//  Created by Jeffrey Zhang on 2020-05-06.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

@testable import StickyLayout
import UIKit
import XCTest

class StickyLayoutConfigTests: XCTestCase {
    
    let emptySet = Set<Int>()
    var collectionView: UICollectionView!
    var mockDataProvider: MockDataProvider!
    var stickylayout: StickyLayout!

    var dataModel = [[0, 1, 2], [3, 4, 5], [6, 7]]
    
    class MockDataProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        weak var parent: StickyLayoutConfigTests! = nil
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.dataModel[section].count
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return parent.dataModel.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 120, height: 120)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    }
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockDataProvider()
        mockDataProvider.parent = self
        self.dataModel = [[0, 1, 2], [3, 4, 5], [6, 7]]
        self.stickylayout = StickyLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: stickylayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = mockDataProvider
        collectionView.dataSource = mockDataProvider
    }
    
    func testCollectionViewCellsCount() {
        XCTAssertEqual(mockDataProvider.numberOfSections(in: collectionView), 3)
        XCTAssertEqual(mockDataProvider.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(mockDataProvider.collectionView(collectionView, numberOfItemsInSection: 1), 3)
        XCTAssertEqual(mockDataProvider.collectionView(collectionView, numberOfItemsInSection: 2), 2)
    }
    
    func testCollectionViewContentSizeAfterSectionDeletion() {
        stickylayout.prepare()
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 360))
        self.dataModel.remove(at: 2)
        self.collectionView.deleteSections(IndexSet(arrayLiteral: 2))
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 240))
    }
    
    func testCollectionViewContentSizeAfterSectionInsertion() {
        stickylayout.prepare()
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 360))
        self.dataModel.append([8, 9, 10])
        self.collectionView.insertSections(IndexSet(arrayLiteral: 3))
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 480))
    }
    
    func testCollectionViewContentSizeAfterItemDeletion() {
        stickylayout.prepare()
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 360))
        self.dataModel[0] = [0, 1]
        self.dataModel[1] = [2, 3]
        self.collectionView.deleteItems(at: [IndexPath(item: 2, section: 0), IndexPath(item: 2, section: 1)])
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 240, height: 360))
    }
    
    func testCollectionViewContentSizeAfterItemInsertion() {
        stickylayout.prepare()
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 360, height: 360))
        self.dataModel[0].append(5)
        self.collectionView.insertItems(at: [IndexPath(item: 3, section: 0)])
        XCTAssertEqual(stickylayout.collectionViewContentSize, CGSize(width: 480, height: 360))
    }


    // MARK: - Sticky Config Tests
    func testEmptyStickyConfigWithEmptyLayout() throws {
        let emptyStickyConfig = StickyLayoutConfig(stickyRowsFromTop: 0,
                                                                stickyRowsFromBottom: 0,
                                                                stickyColsFromLeft: 0,
                                                                stickyColsFromRight: 0)
        XCTAssertEqual(emptyStickyConfig.getBottomStickyRows(rowCount: 0), emptySet)
        XCTAssertEqual(emptyStickyConfig.getTopStickyRows(rowCount: 0), emptySet)
        XCTAssertEqual(emptyStickyConfig.getLeftStickyCols(colCount: 0), emptySet)
        XCTAssertEqual(emptyStickyConfig.getRightStickyCols(colCount: 0), emptySet)
 
        XCTAssertEqual(emptyStickyConfig.getStickyRows(rowCount: 0), emptySet)

        XCTAssertEqual(emptyStickyConfig.getStickyCols(colCount: 0), emptySet)
    }

    func testEmptyStickyConfigWithPopulatedLayout() throws {
        let emptyStickyConfig = StickyLayoutConfig(stickyRowsFromTop: 0,
                                                                stickyRowsFromBottom: 0,
                                                                stickyColsFromLeft: 0,
                                                                stickyColsFromRight: 0)
        XCTAssertEqual(emptyStickyConfig.getBottomStickyRows(rowCount: 100), emptySet)
        XCTAssertEqual(emptyStickyConfig.getTopStickyRows(rowCount: 100), emptySet)
        XCTAssertEqual(emptyStickyConfig.getLeftStickyCols(colCount: 100), emptySet)
        XCTAssertEqual(emptyStickyConfig.getRightStickyCols(colCount: 100), emptySet)

        XCTAssertEqual(emptyStickyConfig.getStickyRows(rowCount: 100), emptySet)

        XCTAssertEqual(emptyStickyConfig.getStickyCols(colCount: 100), emptySet)
    }
    
    func testDefaultStickyConfig() throws {
        let defaultStickyConfig = StickyLayoutConfig()
        let defaultSet = Set<Int>([0])

        XCTAssertEqual(defaultStickyConfig.getBottomStickyRows(rowCount: 100), emptySet)
        XCTAssertEqual(defaultStickyConfig.getBottomStickyRows(rowCount: 2), emptySet)

        XCTAssertEqual(defaultStickyConfig.getTopStickyRows(rowCount: 100), defaultSet)
        XCTAssertEqual(defaultStickyConfig.getTopStickyRows(rowCount: 1), defaultSet)

        XCTAssertEqual(defaultStickyConfig.getLeftStickyCols(colCount: 100), defaultSet)
        XCTAssertEqual(defaultStickyConfig.getLeftStickyCols(colCount: 1), defaultSet)

        XCTAssertEqual(defaultStickyConfig.getRightStickyCols(colCount: 100), emptySet)
        XCTAssertEqual(defaultStickyConfig.getRightStickyCols(colCount: 12), emptySet)

        XCTAssertEqual(defaultStickyConfig.getStickyRows(rowCount: 100), defaultSet)
        XCTAssertEqual(defaultStickyConfig.getStickyRows(rowCount: 1), defaultSet)

        XCTAssertEqual(defaultStickyConfig.getStickyCols(colCount: 100), defaultSet)
        XCTAssertEqual(defaultStickyConfig.getStickyCols(colCount: 1), defaultSet)
    }
    
    func testDefaultStickyConfigEmptyLayout() throws {
        let defaultStickyConfig = StickyLayoutConfig()

        XCTAssertEqual(defaultStickyConfig.getBottomStickyRows(rowCount: 0), emptySet)
        XCTAssertEqual(defaultStickyConfig.getTopStickyRows(rowCount: 0), emptySet)
        XCTAssertEqual(defaultStickyConfig.getLeftStickyCols(colCount: 0), emptySet)
        XCTAssertEqual(defaultStickyConfig.getRightStickyCols(colCount: 0), emptySet)

        XCTAssertEqual(defaultStickyConfig.getStickyRows(rowCount: 0), emptySet)

        XCTAssertEqual(defaultStickyConfig.getStickyCols(colCount: 0), emptySet)
    }

    func testNormalStickyConfig() throws {
        let defaultStickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1,
                                                                  stickyRowsFromBottom: 2,
                                                                  stickyColsFromLeft: 1,
                                                                  stickyColsFromRight: 1)

        XCTAssertEqual(defaultStickyConfig.getBottomStickyRows(rowCount: 50), Set<Int>([48, 49]))
        XCTAssertEqual(defaultStickyConfig.getTopStickyRows(rowCount: 50), Set<Int>([0]))
        XCTAssertEqual(defaultStickyConfig.getLeftStickyCols(colCount: 50), Set<Int>([0]))
        XCTAssertEqual(defaultStickyConfig.getRightStickyCols(colCount: 50), Set<Int>([49]))

        XCTAssertEqual(defaultStickyConfig.getStickyRows(rowCount: 50), Set<Int>([0, 48, 49]))
        XCTAssertEqual(defaultStickyConfig.getStickyCols(colCount: 50), Set<Int>([0, 49]))
    }

    func testOverlappingStickyConfig() throws {
        let stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 5,
                                                                stickyRowsFromBottom: 3,
                                                                stickyColsFromLeft: 2,
                                                                stickyColsFromRight: 10)
        XCTAssertEqual(stickyConfig.getBottomStickyRows(rowCount: 3), Set<Int>([0, 1, 2]))
        XCTAssertEqual(stickyConfig.getTopStickyRows(rowCount: 5), Set<Int>([0, 1, 2, 3, 4]))
        XCTAssertEqual(stickyConfig.getLeftStickyCols(colCount: 7), Set<Int>([0, 1]))
        XCTAssertEqual(stickyConfig.getRightStickyCols(colCount: 10), Set<Int>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))

        XCTAssertEqual(stickyConfig.getStickyRows(rowCount: 4), Set<Int>([0, 1, 2, 3]))
        XCTAssertEqual(stickyConfig.getStickyRows(rowCount: 5), Set<Int>([0, 1, 2, 3, 4]))

        XCTAssertEqual(stickyConfig.getStickyCols(colCount: 10), Set<Int>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
    }
    
    func testOverflowingStickyConfig() throws {
        let stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 500,
                                                                stickyRowsFromBottom: 300,
                                                                stickyColsFromLeft: 200,
                                                                stickyColsFromRight: 100)
        XCTAssertEqual(stickyConfig.getBottomStickyRows(rowCount: 3), Set<Int>([0, 1, 2]))
        XCTAssertEqual(stickyConfig.getTopStickyRows(rowCount: 5), Set<Int>([0, 1, 2, 3, 4]))
        XCTAssertEqual(stickyConfig.getLeftStickyCols(colCount: 2), Set<Int>([0, 1]))
        XCTAssertEqual(stickyConfig.getRightStickyCols(colCount: 10), Set<Int>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
        XCTAssertEqual(stickyConfig.getStickyRows(rowCount: 4), Set<Int>([0, 1, 2, 3]))

        XCTAssertEqual(stickyConfig.getStickyCols(colCount: 10), Set<Int>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

