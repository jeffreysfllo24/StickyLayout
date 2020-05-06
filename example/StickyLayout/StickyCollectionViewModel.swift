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
    var stickyConfig = StickyLayoutConfig()
    var rowCount = 20
    
    func colCount(forRow row: Int) -> Int {
        if row == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func backgroundColor() -> UIColor {
        return .brown
    }
    
    func interItemSpacing() -> CGFloat {
        return 0
    }
    
    func sectionSpacing() -> CGFloat {
        return 0
    }
    
    func getCellSize(indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 375, height: 50)

        } else {
            return CGSize(width: 100, height: 50)
        }
    }
    
    func layoutCell(collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as? CalendarCell else {
            return CalendarCell()
        }
        cell.backgroundColor = UIColor(hex: "#f0f0edff")
        cell.label.text = "\(indexPath.section)"
        cell.layer.cornerRadius = 10
        return cell
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
