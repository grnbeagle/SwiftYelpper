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


    override func viewDidLoad() {
        super.viewDidLoad()

        currentLocation = CLLocation(latitude: 37.7873589, longitude: -122.408227)!

        var client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        client.searchWithTerm(searchTerm, filters: filters, location: currentLocation!, offset: offset,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                if let data = response as? Dictionary<String, AnyObject> {
                    let businesses = data["businesses"] as? [NSDictionary]
                    if let businesses = businesses {
                        self.places = Place.placesWithArray(businesses)
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
