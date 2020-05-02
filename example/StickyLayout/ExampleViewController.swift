//
//  ViewController.swift
//  StickyLayout
//
//  Created by Jeffrey Zhang on 2020-04-28.
//  Copyright © 2020 Jeffrey Zhang. All rights reserved.
//

import UIKit

class ExampleViewController: UITableViewController {
    
    private enum ExampleCollectionViews {
        case header
        case tabular
        case tabularBottom
    }
    
    private let examples: [ExampleCollectionViews] = [.header, .tabular, .tabularBottom]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Examples Title"
        self.view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // TODO: Set title
        cell.textLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}
