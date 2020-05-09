//
//  ViewController.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-04-28.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import UIKit

public enum StickyLayoutTypes {
    case calendar
    case tabular
    case horizontal
    
    func title() -> String {
        switch self {
        case .calendar:
            return "Calendar"
        case .tabular:
            return "Tabular"
        case .horizontal:
            return "Horizontal"
        }
    }
}

class ExamplesListController: UITableViewController {

    private let examples: [StickyLayoutTypes] = [.calendar, .tabular, .horizontal]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Sticky Layout Examples"
        self.view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = examples[indexPath.row].title()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ExampleStickyController(stickLayoutType: examples[indexPath.row]), animated: true)
    }
}
