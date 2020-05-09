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
    
    private let firstSplitIntervals = [55, 63, 44, 60, 50]
    private let secondSplitIntervals = [58, 73, 70, 65, 52]
    private let thirdSplitIntervals = [65, 53, 65, 66, 57]
    private let fourthSplitIntervals = [68, 63, 80, 67, 60]
    private let fifthSplitIntervals = [59, 63, 90, 60, 55]
    private let swimmers = ["Phelps", "Lochte", "Henry", "John", "Larry"]
    
    private var cellText: [[String]] = []
    
    init() {
        var cellText = [["", "Lap 1", "Lap 2", "Lap 3", "Lap 4", "Lap 5", "Total"]]
        for index in 0..<swimmers.count {
            var individualTimes: [String] = []
            individualTimes.append(swimmers[index])
            individualTimes.append(formatInterval(interval: firstSplitIntervals[index]))
            individualTimes.append(formatInterval(interval: secondSplitIntervals[index]))
            individualTimes.append(formatInterval(interval: thirdSplitIntervals[index]))
            individualTimes.append(formatInterval(interval: fourthSplitIntervals[index]))
            individualTimes.append(formatInterval(interval: fifthSplitIntervals[index]))
            
            let totalIntervals = firstSplitIntervals[index] +
                                 secondSplitIntervals[index] +
                                 thirdSplitIntervals[index] +
                                 fourthSplitIntervals[index] +
                                 fifthSplitIntervals[index]
            individualTimes.append(formatInterval(interval: totalIntervals))
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
        return CGSize(width: 70, height: 50)
    }
    
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCell.reuseIdentifier, for: indexPath) as? LabelCell else {
            return LabelCell()
        }
        return cell
    }
    
    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell) {
        guard let cell = cell as? LabelCell else {
            return
        }
        let isFirstRow = indexPath.section == 0
        let isLastCol = indexPath.item == colCount(forRow: indexPath.section) - 1
        let isFirstCol = indexPath.section == 0
        
        cell.label.frame = cell.bounds
        cell.label.text = cellText[indexPath.section][indexPath.item]
        cell.backgroundColor = (isFirstCol || isLastCol) ? UIColor(hex: "#61D0EAff") : UIColor(hex: "#5BC6DFff")
        cell.label.textColor = .white
        cell.label.alpha = (isFirstRow || isFirstCol || isLastCol)  ? 1 : 0.7
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
