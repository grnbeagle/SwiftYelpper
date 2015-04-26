//
//  ListingViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/23/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import CoreLocation

class ListingViewController: UIViewController {

    let yelpConsumerKey = "U2QFU5uHJxGv-AJ5AETcZQ"
    let yelpConsumerSecret = "dC0s_eZ9k8n4lL-HkIXf0s_6Yag"
    let yelpToken = "83WWEIxzNfHFU6sEcdApE1uz_9T00-FR"
    let yelpTokenSecret = "ntw6alKMfabeHK1k4sLhN9IkomU"

    var searchTerm = "food"
    var currentLocation: CLLocation?
    var offset = 0
    var filters = NSDictionary()
    var places: [Place]?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        currentLocation = CLLocation(latitude: 37.7873589, longitude: -122.408227)!
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        var client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        client.searchWithTerm(searchTerm, filters: filters, location: currentLocation!, offset: offset,
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
