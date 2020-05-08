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
    var stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1, stickyRowsFromBottom: 2, stickyColsFromLeft: 1, stickyColsFromRight: 1)
    
    private let cellText = [
        ["Expense Summary 2019"],
        ["", "Messages", "Minutes", "Data", "Long Distance", "Individual Expense Percentage"],
        ["Charley", "$20", "$5", "$100", "$200", "30%"],
        ["Dan", "$3", "$47", "$5", "$65", "8%"],
        ["Jacob", "$30", "$84", "$5", "$26", "8%"],
        ["Olivia", "$23", "$44", "$5", "$96", "8%"],
        ["David", "$34", "$43", "$5", "426", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Heather", "$13", "$41", "$5", "$46", "8%"],
        ["Category Total Cost", "$123", "$253", "125", "859", ""],
        ["Category Percentage Cost", "9.0%", "18.6%", "9.2%", "63.2%", ""]
    ]
    
    var rowCount: Int {
        return cellText.count
    }
    
    func colCount(forRow row: Int) -> Int {
        cellText[row].count
    }
    
    func backgroundColor() -> UIColor {
        return .white
    }
    
    func interItemSpacing() -> CGFloat {
        0
    }
    
    func sectionSpacing() -> CGFloat {
        0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 375, height: 50)
        }
        return CGSize(width: 100, height: 50)
    }
    
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell else {
            return CalendarCell()
        }
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(hex: "#fbfbfbff")
        } else if indexPath.section % 2 == 0 {
            cell.backgroundColor = .white
        } else if indexPath.section % 2 == 1 {
            cell.backgroundColor = UIColor(hex: "#eff0f2ff")
        }
        cell.label.textColor = .black
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: CalendarCell, indexPath: IndexPath) {
        cell.label.text = cellText[indexPath.section][indexPath.item]
        cell.label.font = indexPath.section == 0 ? UIFont.boldSystemFont(ofSize: 20.0) : UIFont.systemFont(ofSize: 12)
    }
    
}
