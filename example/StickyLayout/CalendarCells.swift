//
//  CalendarCells.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-04.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

public class CalendarCell: UICollectionViewCell {
    lazy var label = UILabel()
    static let reuseIdentifier: String = "CalendarCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.clipsToBounds = true
        label.frame = self.bounds
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
