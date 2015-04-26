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

        placeImageView.layer.cornerRadius = 3
        placeImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        var selectedBackgroundView = UIView(frame: self.frame)
        selectedBackgroundView.backgroundColor = UIColor.yelpperLightGrayColor()
        self.selectedBackgroundView = selectedBackgroundView
    }

    func setPlace(place: Place) {
        placeImageView.image = nil
        ratingView.image = nil

        nameLabel.text = place.name
        addressLabel.text = place.address
        placeImageView.loadAsync(place.imageThumbUrl!, animate: true, failure: nil)
        ratingView.loadAsync(place.imageRatingUrl!, animate: false, failure: nil)
        if let categories = place.categories {
            categoriesLabel.text = categories[0][0] as? String
        }
        var review = place.reviewCount > 1 ? "reviews" : "review"
        ratingCountLabel.text = "\(place.reviewCount!) \(review)"
        distanceLabel.text = String(format: "%0.1f mi", arguments: [place.distance!])
    }
}
