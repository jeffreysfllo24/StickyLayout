//
//  CalendarCells.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-04.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol Cell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
}

public class CalendarCell: UICollectionViewCell, Cell {
    
    static let reuseIdentifier: String = "CalendarCell"
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .center
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
