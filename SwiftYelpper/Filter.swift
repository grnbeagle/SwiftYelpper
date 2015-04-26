//
//  Filter.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

class Filter {
    var title: String
    var entries: [Dictionary<String, String>]

    init(title: String, entries: [Dictionary<String, String>]) {
        self.title = title
        self.entries = entries
    }

    class func getDistanceOptions() -> [Dictionary<String, String>] {
        let options = [
            ["name": "Auto", "value": "auto"],
            ["name": "1 mile", "value": "\(Filter.convertToMeter(1))"],
            ["name": "5 mile", "value": "\(Filter.convertToMeter(5))"],
            ["name": "10 mile", "value": "\(Filter.convertToMeter(10))"],
            ["name": "20 mile", "value": "\(Filter.convertToMeter(20))"]
        ]
        return options
    }

    class func getSortOptions() -> [Dictionary<String, String>] {
        let options = [
            ["name": "Best match", "value": "0"],
            ["name": "Distance", "value": "1"],
            ["name": "Highest rated", "value": "2"],
        ]
        return options
    }

    class func getCategories() -> [Dictionary<String, String>] {
        let categories = [
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
        ]
        return categories
    }

//    ["name" : "African", "code": "african"],
//    ["name" : "American, New", "code": "newamerican"],
//    ["name" : "American, Traditional", "code": "tradamerican"],
//    ["name" : "Asian Fusion", "code": "asianfusion"],
//    ["name" : "Beer Garden", "code": "beergarden"],
//    ["name" : "Belgian", "code": "belgian"],
//    ["name" : "Brasseries", "code": "brasseries"],
//    ["name" : "Brazilian", "code": "brazilian"],
//    ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
//    ["name" : "Cafes", "code": "cafes"],
//    ["name" : "Cafeteria", "code": "cafeteria"],
//    ["name" : "Chinese", "code": "chinese"],
//    ["name" : "Dumplings", "code": "dumplings"],
//    ["name" : "Eastern European", "code": "eastern_european"],
//    ["name" : "Ethiopian", "code": "ethiopian"],
//    ["name" : "Fast Food", "code": "hotdogs"],
//    ["name" : "French", "code": "french"],
//    ["name" : "Hawaiian", "code": "hawaiian"],
//    ["name" : "Indian", "code": "indpak"],
//    ["name" : "Indonesian", "code": "indonesian"],
//    ["name" : "Irish", "code": "irish"],
//    ["name" : "Japanese", "code": "japanese"],
//    ["name" : "Jewish", "code": "jewish"],
//    ["name" : "Korean", "code": "korean"],
//    ["name" : "Kosher", "code": "kosher"],
//    ["name" : "Mexican", "code": "mexican"],
//    ["name" : "Persian/Iranian", "code": "persian"],
//    ["name" : "Peruvian", "code": "peruvian"],
//    ["name" : "Pizza", "code": "pizza"],
//    ["name" : "Russian", "code": "russian"],
//    ["name" : "Salad", "code": "salad"],
//    ["name" : "Sandwiches", "code": "sandwiches"],
//    ["name" : "Scandinavian", "code": "scandinavian"],
//    ["name" : "Seafood", "code": "seafood"],
//    ["name" : "Soul Food", "code": "soulfood"],
//    ["name" : "Soup", "code": "soup"],
//    ["name" : "Spanish", "code": "spanish"],
//    ["name" : "Steakhouses", "code": "steak"],
//    ["name" : "Tapas Bars", "code": "tapas"],
//    ["name" : "Thai", "code": "thai"],
//    ["name" : "Turkish", "code": "turkish"],
//    ["name" : "Vegetarian", "code": "vegetarian"],
//    ["name" : "Wraps", "code": "wraps"]

    class func convertToMeter(miles: Float) -> Float {
        return miles * 1609
    }
}