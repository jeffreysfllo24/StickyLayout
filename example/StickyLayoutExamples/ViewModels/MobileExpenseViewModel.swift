//
//  MobileExpenseViewModel.swift
//  StickyLayoutExamples
//
//  Created by Jeffrey Zhang on 2020-05-07.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import StickyLayout

public class MobileExpenseViewModel: StickyCollectionViewModel {
    var stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1,
                                          stickyRowsFromBottom: 2,
                                          stickyColsFromLeft: 1,
                                          stickyColsFromRight: 0)
    
    private let messagesCosts = [20, 47, 30, 23, 34, 13, 15, 42, 53, 12, 43, 12, 34, 45, 65]
    private let minutesCosts = [5, 41, 40, 22, 74, 43, 15, 122, 23, 14, 0, 2, 0, 93, 11]
    private let dataCosts = [4, 0, 340, 23, 31, 13, 25, 32, 6, 33, 90, 22, 8, 0, 10]
    private let longDistanceCosts = [14, 24, 43, 2, 21, 23, 54, 43, 54, 2, 0, 0, 4, 5, 2]
    
    private var messagesTotalCost: Int {
        return messagesCosts.reduce(0, +)
    }
    
    private var minutesTotalCost: Int {
        return minutesCosts.reduce(0, +)
    }
    
    private var dataTotalCost: Int {
        return dataCosts.reduce(0, +)
    }
    
    private var longDistanceTotalCost: Int {
        return longDistanceCosts.reduce(0, +)
    }
    
    private var totalExpense: Int {
        return messagesTotalCost + minutesTotalCost + dataTotalCost + longDistanceTotalCost
    }

    private let names = ["Charley", "Dan", "Jacob", "Olivia", "David", "Heather", "Beth", "John",
                         "Jazz", "Simon", "Don", "Ronald", "Jay", "Carl", "Luke"]
    
    private var cellText: [[String]] = []
    
    init() {
        var cellText = [["Names", "Messages", "Minutes", "Data", "Long Distance"]]
        for index in 0..<names.count {
            var individualExpense: [String] = []
            individualExpense.append(names[index])
            individualExpense.append("$" + String(messagesCosts[index]))
            individualExpense.append("$" + String(minutesCosts[index]))
            individualExpense.append("$" + String(dataCosts[index]))
            individualExpense.append("$" + String(longDistanceCosts[index]))
            cellText.append(individualExpense)
        }
        
        let totalCategoryExpense = ["Total",
                                    "$" + String(messagesTotalCost),
                                    "$" + String(minutesTotalCost),
                                    "$" + String(dataTotalCost),
                                    "$" + String(longDistanceTotalCost)]
        cellText.append(totalCategoryExpense)
        
        let expensePercentage = ["Percentage",
                                 String(messagesTotalCost * 100/totalExpense ) + "%",
                                 String(minutesTotalCost * 100/totalExpense) + "%",
                                 String(dataTotalCost * 100/totalExpense) + "%",
                                 String(longDistanceTotalCost * 100/totalExpense) + "%"]
        cellText.append(expensePercentage)
        self.cellText = cellText
    }
    
    var rowCount: Int {
        return cellText.count
    }
    
    func colCount(forRow row: Int) -> Int {
        cellText[row].count
    }
    
    func backgroundColor() -> UIColor {
        return UIColor(hex: "#EAEAEAff")!
    }
    
    func interItemSpacing() -> CGFloat {
        0
    }
    
    func sectionSpacing() -> CGFloat {
        0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        if (rowCount - indexPath.section <= 2) && (indexPath.item == colCount(forRow: indexPath.section) - 1) {
            return CGSize(width: 140, height: 50)
        } else if rowCount - indexPath.section <= 2 {
            return CGSize(width: 100, height: 50)
        } else if indexPath.item == colCount(forRow: indexPath.section) - 1 {
            return CGSize(width: 140, height: 50)
        }
        return CGSize(width: 100, height: 50)
    }

    func setCellStyle(collectionView: UICollectionView, indexPath: IndexPath, cell: UICollectionViewCell) {
        guard let cell = cell as? LabelCell else {
            return
        }
        
        cell.label.textColor = .black
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(hex: "#F4F4F4ff")
            cell.label.textColor = UIColor(hex: "#7c9dfcff")
        } else if rowCount - indexPath.section <= 2 {
            cell.backgroundColor = UIColor(hex: "#E5E5E5ff")
        } else if indexPath.section % 2 == 0 {
            cell.backgroundColor = .white
        } else if indexPath.section % 2 == 1 {
            cell.backgroundColor = UIColor(hex: "#eff0f2ff")
        }
        configureCell(cell: cell, indexPath: indexPath)
        cell.label.frame = cell.bounds
    }
    
    private func configureCell(cell: LabelCell, indexPath: IndexPath) {
        cell.label.text = cellText[indexPath.section][indexPath.item]
        cell.label.alpha = (indexPath.section == 0 || indexPath.item == 0 || rowCount - indexPath.section <= 2) ? 1 : 0.5
        cell.label.font = (indexPath.section == 0 || indexPath.item == 0) ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 12)
    }
    
}
