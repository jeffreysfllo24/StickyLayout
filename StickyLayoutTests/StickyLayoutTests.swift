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

class StickyLayoutTests: XCTestCase {
    
    var collectionView: UICollectionView!
    var mockDataProvider: MockDataProvider!
    var stickylayout: StickyLayout!

    var dataModel = [[0, 1, 2], [3, 4, 5], [6, 7]]
    
    class MockDataProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        weak var parent: StickyLayoutTests! = nil
        
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
        self.stickylayout = StickyLayout(stickyConfig: StickyLayoutConfig(stickyRowsFromTop: 10,
                                                                          stickyRowsFromBottom: 10,
                                                                          stickyColsFromLeft: 10,
                                                                          stickyColsFromRight: 10))
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
    
    func testCollectionViewLayoutAttributes() {
        stickylayout.prepare()
        let visibleCells = stickylayout.layoutAttributesForElements(in: collectionView.frame)
        XCTAssertEqual(visibleCells?.count, 8)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

