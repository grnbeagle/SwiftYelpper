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
    var imageThumbUrl: String?
    var imageRatingUrl: String?
    var category: [String]?
    var distance: Float?
    var reviewCount: Int?

    init() {

    }

    convenience init(dict: NSDictionary) {
        self.init()

        name = dict["name"] as? String
    }

    class func placesWithArray(array: [NSDictionary]) -> [Place] {
        var places: [Place] = []
        for item in array {
            places.append(Place(dict: item))
        }
        return places
    }
}