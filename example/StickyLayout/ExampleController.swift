//
//  ExampleController.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-05-02.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import Foundation
import UIKit

class ExampleStickyController: UIViewController {
    
    let stickyLayoutType: StickyLayoutTypes
    
    init(stickLayoutType: StickyLayoutTypes) {
        stickyLayoutType = stickLayoutType
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
