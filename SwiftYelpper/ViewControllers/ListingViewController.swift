//
//  ListingViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/23/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import CoreLocation

class ListingViewController: UIViewController, UITextFieldDelegate {

    let yelpConsumerKey = "U2QFU5uHJxGv-AJ5AETcZQ"
    let yelpConsumerSecret = "dC0s_eZ9k8n4lL-HkIXf0s_6Yag"
    let yelpToken = "83WWEIxzNfHFU6sEcdApE1uz_9T00-FR"
    let yelpTokenSecret = "ntw6alKMfabeHK1k4sLhN9IkomU"

    var yelpClient: YelpClient?
    var searchTerm = ""
    var currentLocation: CLLocation?
    var offset = 0
    var filters = NSDictionary()
    var places: [Place]?

    var searchView: UIView?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        yelpClient = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        currentLocation = CLLocation(latitude: 37.7873589, longitude: -122.408227)!
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        createSearchView()
        search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSearchView() {
        //var containerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 40))
        var searchField = UITextField(frame: CGRectMake(0, 0, view.frame.width - 100, 30))
        searchField.delegate = self
        searchField.placeholder = "Search"
        searchField.text = searchTerm
        searchField.font = UIFont.systemFontOfSize(14)
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        searchField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchField.autocorrectionType = UITextAutocorrectionType.No

        //var filterButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "showFilter")

        navigationItem.titleView = searchField
        //navigationItem.leftBarButtonItem = filterButton
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchTerm = textField.text
        search()
        return true
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchTerm = ""
        search()
        return true
    }

    func search() {
        yelpClient!.searchWithTerm(searchTerm, filters: filters, location: currentLocation!, offset: offset,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let data = response as? Dictionary<String, AnyObject> {
                    let businesses = data["businesses"] as? [NSDictionary]
                    if let businesses = businesses {
                        self.places = Place.placesWithArray(businesses)
                        self.tableView.reloadData()
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        var filterVC = segue.destinationViewController as? FilterViewController
        
    }

}

extension ListingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = places {
            return places.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceCell
        let place = places![indexPath.row]
        cell.setPlace(place)
        return cell
    }
}
