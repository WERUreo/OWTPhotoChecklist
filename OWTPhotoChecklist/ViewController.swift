//
//  ViewController.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 4/29/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    let locationsURLString = "https://brigades.opendatanetwork.com/resource/hzkr-id6u.json"

    ////////////////////////////////////////////////////////////
    // MARK: - Outlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var mapView: MKMapView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    lazy var locationManager = CLLocationManager()
    var locations = [Location]()

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow

        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = userTrackingButton

        retrieveLocations()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - CLLocationManagerDelegate
    ////////////////////////////////////////////////////////////

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
    }

    ////////////////////////////////////////////////////////////

    func retrieveLocations()
    {
        Alamofire.request(.GET, locationsURLString).validate().responseJSON
        { response in
            switch response.result
            {
            case .Success:
                if let value = response.result.value
                {
                    let json = JSON(value)
                    for (_, subJson) in json
                    {
                        self.locations.append(Location(json: subJson))
                    }

                    var annotations = [MKPointAnnotation]()
                    for location in self.locations
                    {
                        let annotation = MKPointAnnotation()
                        annotation.title = location.title
                        annotation.subtitle = location.address
                        annotation.coordinate = location.location
                        annotations.append(annotation)
                    }

                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.mapView.showAnnotations(annotations, animated: true)

                        if let userLocation = self.mapView.userLocation.location?.coordinate
                        {
                            self.mapView.centerCoordinate = userLocation

                            let region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(0.1, 0.1))
                            self.mapView.region = region
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
