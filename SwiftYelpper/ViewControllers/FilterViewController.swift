//
//  FilterViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filterViewController(filterViewController: FilterViewController, didUpdateFilters filters: [String: AnyObject])
}

class FilterViewController: UIViewController {

    let filters:[Filter] = [
        Filter(title: "Most Popular", filterKey: "deals_filter", entries: Filter.getMostPopularOptions(), filterType: .Toggle),
        Filter(title: "Distance", filterKey: "radius_filter", entries: Filter.getDistanceOptions(), filterType: .Single),
        Filter(title: "Sort by", filterKey: "sort", entries: Filter.getSortOptions(), filterType: .Single),
        Filter(title: "Categories", filterKey: "category_filter", entries: Filter.getCategories(), filterType: .Multiple)
    ]

    var filterStates = [NSIndexPath: Bool]()
    weak var delegate: FilterViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!

    var expanded = [Int: Bool]() // if filter index exists, it's expanded

    let maxRowsCollapsed = 5    // for multiple filter type, show at most 5 rows when collapsed

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        updateObjectStyles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateObjectStyles() {
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = UIColor.yelpperRedColor()
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
            navigationController.navigationBar.barStyle = .Black
        }
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)
        searchButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)

        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
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
    @IBAction func search(sender: AnyObject) {
        var selectedFilters = [String: [String]]()
        for (indexPath, isSelected) in filterStates {
            if isSelected {
                let filter = filters[indexPath.section] as Filter
                let filterEntry = filter.entries[indexPath.row]
                if selectedFilters[filter.filterKey] == nil {
                    selectedFilters[filter.filterKey] = []
                }
                selectedFilters[filter.filterKey]?.append(filterEntry["value"]!)
            }
        }
        var apiFriendlyFilters = [String: String]()
        for (key, list) in selectedFilters {
            apiFriendlyFilters[key] = ",".join(list)
        }
        println(apiFriendlyFilters)
        delegate?.filterViewController?(self, didUpdateFilters: apiFriendlyFilters)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filters.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = filters[section]
        if isExpanded(section) {
            return filter.entries.count
        } else {
            if filter.filterType == .Multiple && filter.entries.count > maxRowsCollapsed {
                return maxRowsCollapsed
            } else {
                return 1
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let filter = filters[indexPath.section] as Filter
        let selectedEntry = filter.getSelectedEntry()
        var showFilterCell = isExpanded(indexPath.section) || filter.filterType == .Toggle
        if showFilterCell {
            let filterEntry = filter.entries[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! UITableViewCell
            var filterCell = cell as? FilterCell
            if let filterCell = filterCell {
                filterCell.delegate = self
                filterCell.filterLabel.text = filterEntry["name"]
                if let selectedEntry = selectedEntry {
                    // for Toggle and Single, use filter's selectedEntry
                    filterCell.filterSwitch.setOn(selectedEntry["value"] == filterEntry["value"]!, animated: false)
                } else {
                    // for multiple, use filterStates map
                    filterCell.filterSwitch.on = filterStates[indexPath] ?? false
                }
            }
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            let filterEntry = filter.entries[indexPath.row]
            if let selectedEntry = selectedEntry {
                cell.textLabel!.text = selectedEntry["name"]
            } else if filter.filterType == .Multiple {
                if indexPath.row == maxRowsCollapsed - 1 {
                    cell.textLabel!.text = "See All"
                } else {
                    cell.textLabel!.text = filterEntry["name"]
                }
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var filter = filters[section] as Filter
        return "    \(filter.title)"
    }

    func isExpanded(section: Int) -> Bool {
        return expanded[section] != nil
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filter = filters[indexPath.section] as Filter
        let filterEntry = filter.entries[indexPath.row]
        if isExpanded(indexPath.section) {
            if filter.filterType == .Single || filter.filterType == .Toggle {
                expanded.removeValueForKey(indexPath.section)
            }
        } else {
            expanded.updateValue(true, forKey: indexPath.section)
        }
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

extension FilterViewController: FilterCellDelegate {
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(filterCell)!
        let filter = filters[indexPath.section] as Filter
        let filterEntry = filter.entries[indexPath.row]
        println("filters view got the filter cell event: \(indexPath.row)")

        if value {
            filterStates.updateValue(true, forKey: indexPath)
        } else {
            filterStates.removeValueForKey(indexPath)
        }
        if isExpanded(indexPath.section) {
            if filter.filterType == .Single || filter.filterType == .Toggle {
                filter.selectedEntry = filterEntry
                expanded.removeValueForKey(indexPath.section)
            }
        } else {
            expanded.updateValue(true, forKey: indexPath.section)
        }
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}