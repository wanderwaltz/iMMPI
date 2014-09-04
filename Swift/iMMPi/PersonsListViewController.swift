//
//  PersonsListViewController.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import UIKit

class PersonsListViewController: UITableViewController {
    
    // MARK - initialization methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "Все записи"
    }
    
    
    // MARK - <UITableViewDataSource>
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0;
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
}

