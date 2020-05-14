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
    var stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1,
                                          stickyRowsFromBottom: 0,
                                          stickyColsFromLeft: 1,
                                          stickyColsFromRight: 1)
    
    private let splitIntervals = [[55, 63, 44, 60, 50],
                                  [55, 63, 44, 60, 50],
                                  [65, 53, 65, 66, 57],
                                  [68, 63, 80, 67, 60],
                                  [59, 63, 90, 60, 55],
                                  [60, 69, 63, 70, 62],
                                  [62, 53, 54, 51, 63],
                                  [67, 55, 64, 59, 55]]

    private let swimmers = ["Phelps", "Lochte", "Henry", "John", "Larry"]
    
    private var cellText: [[String]] = []
    
    init() {
        var cellText = [["Swimmers", "Lap 1", "Lap 2", "Lap 3", "Lap 4", "Lap 5", "Lap 6", "Lap 7", "Lap 8", "Total"]]
        for index in 0..<swimmers.count {
            var individualTimes: [String] = []
            individualTimes.append(swimmers[index])
            var totalTime = 0
            for split in splitIntervals {
                individualTimes.append(formatInterval(interval: split[index]))
                totalTime += split[index]
            }
            individualTimes.append(formatInterval(interval: totalTime))
            cellText.append(individualTimes)
        }
        self.cellText = cellText
    }

    var rowCount: Int {
        return cellText.count
    }
    
    func colCount(forRow row: Int) -> Int {
        return cellText[row].count
    }
    
    func backgroundColor() -> UIColor {
        return UIColor(hex: "#C3F2FDff")!
    }
    
    func interItemSpacing() -> CGFloat {
        return 0
    }
    
    func sectionSpacing() -> CGFloat {
        return 0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 50)
    }

    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell) {
        guard let cell = cell as? LabelCell else {
            return
        }
        let isFirstRow = indexPath.section == 0
        let isLastCol = indexPath.item == colCount(forRow: indexPath.section) - 1
        let isFirstCol = indexPath.item == 0
        
        cell.label.frame = cell.bounds
        cell.label.text = cellText[indexPath.section][indexPath.item]
        if isFirstRow {
            cell.backgroundColor = UIColor(hex: "#8EE5F9ff")
        } else if isLastCol || isFirstCol {
            cell.backgroundColor = UIColor(hex: "#61D0EAff")
        } else {
            cell.backgroundColor = UIColor(hex: "#5BC6DFff")
        }
        cell.label.textColor = .white
        cell.label.alpha = (isFirstRow || isFirstCol || isLastCol) ? 1 : 0.7
        cell.label.font = (isFirstRow || isFirstCol || isLastCol) ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 12)
    }
    
    private func formatInterval(interval: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(interval))!
        return formattedString
    }
}
