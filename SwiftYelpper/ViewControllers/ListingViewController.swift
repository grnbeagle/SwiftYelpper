//
//  ListingViewController.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/23/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import CoreLocation

class ListingViewController: UIViewController, UITextFieldDelegate {

    let yelpConsumerKey = "U2QFU5uHJxGv-AJ5AETcZQ"
    let yelpConsumerSecret = "dC0s_eZ9k8n4lL-HkIXf0s_6Yag"
    let yelpToken = "83WWEIxzNfHFU6sEcdApE1uz_9T00-FR"
    let yelpTokenSecret = "ntw6alKMfabeHK1k4sLhN9IkomU"

    var yelpClient: YelpClient?
    var searchTerm = "Restaurants"
    var currentLocation: CLLocation?
    var offset = 0
    var filters = [String: AnyObject]()
    var places: [Place]?
    var isLoading: Bool?
    var isInitialLoad = true

    var searchView: UIView?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        yelpClient = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        isLoading = false
        places = []

        tableView.hidden = true
        currentLocation = CLLocation(latitude: 37.7873589, longitude: -122.408227)!
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        updateObjectStyles()
        createSearchBarView()
        createLoadingIcon()

        search()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSearchBarView() {
        var searchField = UITextField(frame: CGRectMake(0, 0, view.frame.width - 100, 30))
        searchField.delegate = self
        searchField.placeholder = "Search"
        searchField.text = searchTerm
        searchField.font = UIFont.systemFontOfSize(14)
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        searchField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchField.autocorrectionType = UITextAutocorrectionType.No

        navigationItem.titleView = searchField
    }

    func updateObjectStyles() {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        filterButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)
        mapButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)], forState: UIControlState.Normal)
    }

    func createLoadingIcon() {
        var tableFooterView = UIView(frame: CGRectMake(0, 0, view.frame.width, 50))
        var loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        tableView.tableFooterView = tableFooterView
    }

    func search() {
        if isInitialLoad {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
        yelpClient!.searchWithTerm(searchTerm, filters: filters, location: currentLocation!, offset: offset,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                self.isLoading = false
                self.isInitialLoad = false
                if let data = response as? Dictionary<String, AnyObject> {
                    let businesses = data["businesses"] as? [NSDictionary]
                    if let businesses = businesses {
                        self.places! += Place.placesWithArray(businesses)
                        self.tableView.reloadData()
                        if self.offset == 0 {
                            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
                        }
                        self.offset = self.places!.count
                    }
                }
                self.tableView.hidden = false
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                self.tableView.hidden = false
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var navigationController = segue.destinationViewController as? UINavigationController
        if let navigationController = navigationController {
            var filterVC = navigationController.topViewController as? FilterViewController
            var mapVC = navigationController.topViewController as? MapViewController
            if mapVC != nil {
                mapVC!.location = currentLocation
                mapVC!.places = places
            } else if filterVC != nil {
                filterVC!.delegate = self
            }
        } else {
            var detailsVC = segue.destinationViewController as? PlaceDetailsViewController
            if let detailsVC = detailsVC {
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)!
                if places?.count > indexPath.row {
                    detailsVC.place = places![indexPath.row]
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension ListingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if isLoading! {
            return
        }
        if indexPath.row >= self.places!.count - 1 {
            isLoading = true
            search()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PlaceCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ListingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        places = []
        offset = 0
        textField.resignFirstResponder()
        searchTerm = textField.text
        search()
        return true
    }
}

// MARK: - FilterViewControllerDelegate
extension ListingViewController: FilterViewControllerDelegate {
    func filterViewController(filterViewController: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        places = []
        offset = 0
        self.filters = filters
        search()
    }
}
