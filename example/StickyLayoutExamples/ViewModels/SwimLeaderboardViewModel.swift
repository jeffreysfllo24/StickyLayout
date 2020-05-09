//
//  SwimLeaderboardViewModel.swift
//  StickyLayoutExamples
//
//  Created by Jeffrey Zhang on 2020-05-08.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import StickyLayout

public class SwimLeaderboardViewModel: StickyCollectionViewModel {
    var stickyConfig: StickyLayoutConfig = StickyLayoutConfig(stickyRowsFromTop: 1, stickyRowsFromBottom: 0, stickyColsFromLeft: 1, stickyColsFromRight: 1)
    
    var rowCount: Int = 0
    
    func colCount(forRow row: Int) -> Int {
        return 0
    }
    
    func backgroundColor() -> UIColor {
        return .white
    }
    
    func interItemSpacing() -> CGFloat {
        return 0
    }
    
    func sectionSpacing() -> CGFloat {
        return 0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell else {
            return CalendarCell()
        }
        return cell
    }
    
    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell) {
        
        let interval = 27005

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(interval))!
    }
    
}
