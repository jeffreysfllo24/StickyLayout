//
//  StickyCollectionViewModel.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-05.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol StickyCollectionViewModel {
    //Sticky Configuration
    var stickyConfig: StickyLayoutConfig { get }
    
    // Dimensions
    var rowCount: Int { get }
    func colCount(forRow row: Int) -> Int
    
    // Style
    func backgroundColor() -> UIColor
    
    // Spacing
    func interItemSpacing() -> CGFloat
    func sectionSpacing() -> CGFloat
    
    // Sizing
    func getCellSize(indexPath: IndexPath) -> CGSize
    
    // Cell
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell
}

public class CalendarViewModel: StickyCollectionViewModel {
    var stickyConfig = StickyLayoutConfig(stickyRowsFromTop: 1, stickyRowsFromBottom: 0, stickyColsFromLeft: 1, stickyColsFromRight: 0)
    
    let cellText = [
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
            return CGSize(width: 375, height: 100)
        } else if indexPath.item == 0 {
            return CGSize(width: 80, height: 50)
        } else {
            return CGSize(width: 80, height: 50)
        }
    }
    
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell else {
            return CalendarCell()
        }
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(hex: "#555c64ff")
        } else if indexPath.item == 0 {
            cell.backgroundColor = UIColor(hex: "#EB7059ff")
        } else {
            cell.backgroundColor = UIColor(hex: "#fa775eff")
        }
        cell.label.textColor = .white
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: CalendarCell, indexPath: IndexPath) {
        cell.label.text = cellText[indexPath.section][indexPath.item]
        cell.label.alpha = (indexPath.section == 2 && indexPath.item < 5 && indexPath.item > 0) ? 0.5 : 1
        cell.label.font = indexPath.section == 0 ? UIFont.boldSystemFont(ofSize: 20.0) : UIFont.systemFont(ofSize: 12)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let red, green, blue, alpha: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    alpha = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
}
