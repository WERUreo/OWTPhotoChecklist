//
//  AddLocationVC.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/21/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController, UISearchBarDelegate
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var searchController: UISearchController?
    let dataService = FirebaseDataService()
    var locationType: String = "Building"

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Life Cycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Init the zoom level
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.285849, longitude: -81.055624)
        let mapRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        self.mapView.setRegion(mapRegion, animated: true)    // animate the zoom
    }

    ////////////////////////////////////////////////////////////
    // MARK: - IBActions
    ////////////////////////////////////////////////////////////

    @IBAction func searchButtonTapped(sender: AnyObject)
    {
        self.searchController = UISearchController(searchResultsController: nil)
        if let searchController = self.searchController
        {
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.delegate = self
            presentViewController(searchController, animated: true, completion: nil)
        }
    }

    ////////////////////////////////////////////////////////////
    
    @IBAction func saveButtonTapped(sender: AnyObject)
    {
        let latitude = Double(latitudeField.text ?? "0")
        let longitude = Double(longitudeField.text ?? "0")
        let location = HistoricLocation(name: nameField.text ?? "",
                                        address: addressField.text ?? "",
                                        description: descriptionTextView.text ?? "",
                                        type: locationType,
                                        coordinates: CLLocationCoordinate2DMake(latitude!, longitude!))
        dataService.saveLocation(location)
        dismissViewControllerAnimated(true, completion: nil)
    }

    ////////////////////////////////////////////////////////////

    @IBAction func typeSelected(sender: AnyObject)
    {
        if typeControl.selectedSegmentIndex == 0
        {
            locationType = "Building"
        }
        else if typeControl.selectedSegmentIndex == 1
        {
            locationType = "Sign"
        }
        else if typeControl.selectedSegmentIndex == 2
        {
            locationType = "Park"
        }
    }

    ////////////////////////////////////////////////////////////

    @IBAction func cancelPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    ////////////////////////////////////////////////////////////
    // MARK: - UISearchBarDelegate
    ////////////////////////////////////////////////////////////

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)

        if self.mapView.annotations.count != 0
        {
            let annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }

        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler()
        { response, error in
            guard let response = response else
            {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }

            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)

            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.addAnnotation(pinAnnotationView.annotation!)

            self.addressField.text = searchBar.text
            self.latitudeField.text = "\(response.boundingRegion.center.latitude)"
            self.longitudeField.text = "\(response.boundingRegion.center.longitude)"
        }
    }
}
