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
        Filter(title: "Distance", entries: Filter.getDistanceOptions(), defaultValue: "auto"),
        Filter(title: "Sort by", entries: Filter.getSortOptions(), defaultValue: "0"),
        Filter(title: "Categories", entries: Filter.getCategories(), defaultValue: "")
    ]

    @IBOutlet weak var tableView: UITableView!

    var expanded = [Int: Bool]() // if filter index exists, it's expanded

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = UIColor.yelpperRedColor()
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
            navigationController.navigationBar.barStyle = .Black
        }

        tableView.dataSource = self
        tableView.delegate = self
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
        return isExpanded(section) ? filter.entries.count : 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let filter = filters[indexPath.section] as Filter
        let filterEntry = filter.entries[indexPath.row]
        if isExpanded(indexPath.section) {
            cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            (cell as! FilterCell).filterLabel.text = filterEntry["name"]
            (cell as! FilterCell).filterSwitch.setOn(filter.getCurrentValue() == filterEntry["value"], animated: false)
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            cell.textLabel!.text = filterEntry["name"]
        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var filter = filters[section] as Filter
        return filter.title
    }

    func isExpanded(section: Int) -> Bool {
        return expanded[section] != nil
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isExpanded(indexPath.row) {
            expanded.removeValueForKey(indexPath.section)

        } else {
            expanded.updateValue(true, forKey: indexPath.section)
        }
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}