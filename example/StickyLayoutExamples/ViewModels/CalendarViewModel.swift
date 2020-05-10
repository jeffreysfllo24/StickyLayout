//
//  CalendarViewModel.swift
//  StickyLayoutExamples
//
//  Created by Jeffrey Zhang on 2020-05-07.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import StickyLayout

public class CalendarViewModel: StickyCollectionViewModel {
    var stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1,
                                          stickyRowsFromBottom: 0,
                                          stickyColsFromLeft: 1,
                                          stickyColsFromRight: 0)
    
    private let cellText = [
        ["May 2020"],
        ["", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"],
        ["Week 1", "26", "27", "28", "29", "30", "1", "2"],
        ["Week 2", "3", "4", "5", "6", "7", "8", "9"],
        ["Week 3", "10", "11", "12", "13", "14", "15", "16"],
        ["Week 4", "17", "18", "19", "20", "21", "22", "23"],
        ["Week 5", "24", "25", "26", "27", "28", "29", "30"],
        ["Week 6", "31", "", "", "", "", "", ""]
    ]
    
    var rowCount: Int {
        return cellText.count
    }
    
    func colCount(forRow row: Int) -> Int {
        cellText[row].count
    }
    
    func backgroundColor() -> UIColor {
        return UIColor(hex: "#E26D56ff")!
    }
    
    func interItemSpacing() -> CGFloat {
        return 0
    }
    
    func sectionSpacing() -> CGFloat {
        return 0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 375, height: 60)
        } else if indexPath.item == 0 {
            return CGSize(width: 80, height: 34.3)
        } else {
            return CGSize(width: 70, height: 34.3)
        }
    }
    
    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell) {
        guard let cell = cell as? LabelCell else {
            return
        }
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(hex: "#555c64ff")
            cell.label.font = UIFont.boldSystemFont(ofSize: 20.0)
        } else if indexPath.item == 0 || indexPath.section == 1 {
            cell.backgroundColor = UIColor(hex: "#EB7059ff")
            cell.label.font = UIFont.boldSystemFont(ofSize: 12.0)
        } else {
            cell.backgroundColor = UIColor(hex: "#fa775eff")
            cell.label.font = UIFont.systemFont(ofSize: 12.0)

        }
        cell.label.textColor = .white
        configureCell(cell: cell, indexPath: indexPath)
        cell.label.frame = cell.bounds
    }
    
    private func configureCell(cell: LabelCell, indexPath: IndexPath) {
        cell.label.text = cellText[indexPath.section][indexPath.item]
        cell.label.alpha = (indexPath.section == 2 && indexPath.item < 5 && indexPath.item > 0) ? 0.7 : 1
    }
}
