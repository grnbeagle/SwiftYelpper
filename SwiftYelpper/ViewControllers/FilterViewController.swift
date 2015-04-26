//
//  FilterViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    let filters:[Filter] = [
        Filter(title: "Distance", entries: Filter.getDistanceOptions()),
        Filter(title: "Sort by", entries: Filter.getSortOptions()),
        Filter(title: "Categories", entries: Filter.getCategories())
    ]

    @IBOutlet weak var tableView: UITableView!

    var expanded = [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filters.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = filters[section]
        return filter.entries.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
        var filter = filters[indexPath.section] as Filter
        cell.filterLabel.text = filter.entries[indexPath.row]["name"]
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var filter = filters[section] as Filter
        return filter.title
    }
}