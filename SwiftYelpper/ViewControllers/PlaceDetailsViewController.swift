//
//  PlaceDetailsViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {

    var place: Place?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let place = place {
            navigationItem.title = place.name
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

            nameLabel.text = place.name
            addressLabel.text = place.displayAddress
            placeImageView.loadAsync(place.imageThumbUrl!, animate: true, failure: nil)
            ratingImageView.loadAsync(place.imageRatingUrl!, animate: false, failure: nil)
            if let categories = place.categories {
                categoriesLabel.text = categories[0][0] as? String
            }
            var review = place.reviewCount > 1 ? "reviews" : "review"
            ratingLabel.text = "\(place.reviewCount!) \(review)"
            distanceLabel.text = String(format: "%0.1f mi", arguments: [place.distance!])
        }
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
