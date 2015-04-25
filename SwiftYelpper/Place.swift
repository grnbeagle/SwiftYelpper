//
//  Place.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/23/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

class Place {
    var name: String?
    var address: String?
    var displayAddress: String?
    var imageThumbUrl: NSURL?
    var imageRatingUrl: NSURL?
    var categories: [AnyObject]?
    var distance: Float?
    var reviewCount: Int?

    init() {

    }

    convenience init(dict: NSDictionary) {
        self.init()

        name = dict["name"] as? String
        var addressArray = dict.valueForKeyPath("location.address") as? [String]
        if let addressArray = addressArray {
            address = " ".join(addressArray)
        }

        var displayAddressArray = dict.valueForKeyPath("location.display_address") as? [String]
        if let displayAddressArray = displayAddressArray {
            displayAddress = " ".join(displayAddressArray)
        }

        var urlString = dict.valueForKeyPath("image_url") as? String
        if let urlString = urlString {
            imageThumbUrl = NSURL(string: urlString)
        }

        urlString = dict.valueForKeyPath("rating_img_url") as? String
        if let urlString = urlString {
            imageRatingUrl = NSURL(string: urlString)
        }

        categories = dict["categories"] as? [AnyObject]
        reviewCount = dict["review_count"] as? Int
        distance = dict["distance"] as? Float
    }

    class func placesWithArray(array: [NSDictionary]) -> [Place] {
        var places: [Place] = []
        for item in array {
            places.append(Place(dict: item))
        }
        return places
    }
}