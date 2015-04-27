//
//  Filter.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

enum FilterType {
    case Toggle
    case Single
    case Multiple
}
class Filter {
    var title: String
    var filterKey: String
    var entries: [[String: String]]
    var selectedEntry: [String: String]?
    var filterType: FilterType

    init(title: String, filterKey: String, entries: [[String: String]], filterType: FilterType) {
        self.title = title
        self.filterKey = filterKey
        self.entries = entries
        self.selectedEntry = nil
        self.filterType = filterType
    }

    func getSelectedEntry() -> [String: String]? {
        if let selectedEntry = selectedEntry {
            return selectedEntry
        } else {
            if filterType == .Single {
                // for Single type, return the first item as a default value
                return entries[0]
            } else {
                return nil
            }
        }
    }

    class func getMostPopularOptions() -> [[String: String]] {
        let options: [[String: String]] = [
            ["name": "Offering a Deal", "value": "true"],
        ]
        return options
    }

    class func getDistanceOptions() -> [[String: String]] {
        let options: [[String: String]] = [
            ["name": "Auto", "value": "auto"],
            ["name": "1 mile", "value": "\(Place.convertToMeter(1))"],
            ["name": "5 mile", "value": "\(Place.convertToMeter(5))"],
            ["name": "10 mile", "value": "\(Place.convertToMeter(10))"],
            ["name": "20 mile", "value": "\(Place.convertToMeter(20))"]
        ]
        return options
    }

    class func getSortOptions() -> [[String: String]] {
        let options: [[String: String]] = [
            ["name": "Best match", "value": "0"],
            ["name": "Distance", "value": "1"],
            ["name": "Highest rated", "value": "2"],
        ]
        return options
    }

    class func getCategories() -> [[String: String]] {
        let categories: [[String: String]] = [
            ["name" : "African", "value": "african"],
            ["name" : "American, New", "value": "newamerican"],
            ["name" : "American, Traditional", "value": "tradamerican"],
            ["name" : "Asian Fusion", "value": "asianfusion"],
            ["name" : "Beer Garden", "value": "beergarden"],
            ["name" : "Belgian", "value": "belgian"],
            ["name" : "Brasseries", "value": "brasseries"],
            ["name" : "Brazilian", "value": "brazilian"],
            ["name" : "Cafes", "value": "cafes"],
            ["name" : "Cafeteria", "value": "cafeteria"],
            ["name" : "Chinese", "value": "chinese"],
            ["name" : "Dumplings", "value": "dumplings"],
            ["name" : "Eastern European", "value": "eastern_european"],
            ["name" : "Ethiopian", "value": "ethiopian"],
            ["name" : "Fast Food", "value": "hotdogs"],
            ["name" : "French", "value": "french"],
            ["name" : "Hawaiian", "value": "hawaiian"],
            ["name" : "Indian", "value": "indpak"],
            ["name" : "Indonesian", "value": "indonesian"],
            ["name" : "Irish", "value": "irish"],
            ["name" : "Japanese", "value": "japanese"],
            ["name" : "Jewish", "value": "jewish"],
            ["name" : "Korean", "value": "korean"],
            ["name" : "Kosher", "value": "kosher"],
            ["name" : "Mexican", "value": "mexican"],
            ["name" : "Persian/Iranian", "value": "persian"],
            ["name" : "Peruvian", "value": "peruvian"],
            ["name" : "Pizza", "value": "pizza"],
            ["name" : "Russian", "value": "russian"],
            ["name" : "Salad", "value": "salad"],
            ["name" : "Sandwiches", "value": "sandwiches"],
            ["name" : "Scandinavian", "value": "scandinavian"],
            ["name" : "Seafood", "value": "seafood"],
            ["name" : "Soul Food", "value": "soulfood"],
            ["name" : "Soup", "value": "soup"],
            ["name" : "Spanish", "value": "spanish"],
            ["name" : "Steakhouses", "value": "steak"],
            ["name" : "Tapas Bars", "value": "tapas"],
            ["name" : "Thai", "value": "thai"],
            ["name" : "Turkish", "value": "turkish"],
            ["name" : "Vegetarian", "value": "vegetarian"],
            ["name" : "Wraps", "value": "wraps"]
        ]
        return categories
    }
}