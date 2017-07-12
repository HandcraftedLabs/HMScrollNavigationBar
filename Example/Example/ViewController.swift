//
//  ViewController.swift
//  Example
//
//  Created by Piotr Sękara on 29.06.2017.
//  Copyright © 2017 Handcrafted Mobile Sp. z o.o. All rights reserved.
//

import UIKit
import HMScrollNavigationBar

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        // Primary delegate must be set before setup on navigationBarAnimator !
        self.tableView.delegate = self
        self.navigationBarAnimator.setup(scrollView: self.tableView, navBar: self.navBar)

        self.tableView.refreshControl = refreshControl
        
    }

    @IBAction func testButtonaction(_ sender: Any) {
        self.refreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")!
        cell.textLabel?.text = "Default cell \(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
    }
}

