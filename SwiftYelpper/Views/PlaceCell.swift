//
//  PlaceCell.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/23/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPlace(place: Place) {
        placeImageView.image = nil
        ratingView.image = nil

        nameLabel.text = place.name
        addressLabel.text = place.displayAddress
        placeImageView.loadAsync(place.imageThumbUrl!, animate: true, failure: nil)
        ratingView.loadAsync(place.imageRatingUrl!, animate: false, failure: nil)
        if let categories = place.categories {
            categoriesLabel.text = categories[0][0] as? String
        }
        ratingCountLabel.text = "\(place.reviewCount!)"
        distanceLabel.text = "\(place.distance!)"
    }
}
