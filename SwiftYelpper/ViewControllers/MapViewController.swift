//
//  MapViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    var location: CLLocation?
    var places: [Place]?

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateObjectStyles()
        updateMapAnnotations()
    }

    func updateObjectStyles() {
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = UIColor.yelpperRedColor()
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
            navigationController.navigationBar.barStyle = .Black
        }
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)
    }

    func updateMapAnnotations() {
        if let location = location, places = places {
            var distance: CLLocationDistance = Place.convertToMeter(0.5)
            var viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance)
            mapView.setRegion(viewRegion, animated: true)

            for place in places {
                var address = place.displayAddress
                var geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
                    if placemarks?.count > 0 {
                        var topResult = placemarks?[0] as? CLPlacemark
                        var placemark = MKPlacemark(placemark: topResult)
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = placemark.coordinate
                        annotation.title = place.name
                        annotation.subtitle = place.displayAddress
                        self.mapView.addAnnotation(annotation)
                    }
                })
            }
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

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
