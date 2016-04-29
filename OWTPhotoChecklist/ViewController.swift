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
        
        /*
        if NSUserDefaults.standardUserDefaults().objectForKey("Locations") == nil
        {
            retrieveLocations()
        }
        else
        {
            loadLocations()
        }
        */
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
    // MARK: - MKMapViewDelegate
    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "Location"

        if annotation.isKindOfClass(Location.self)
        {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil
            {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true

                let button = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = button
            }
            else
            {
                annotationView!.annotation = annotation
            }

            return annotationView
        }

        return nil
    }

    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let location = view.annotation as! Location
        let locationName = location.title
        let locationAddress = location.subtitle

        let ac = UIAlertController(title: locationName, message: locationAddress, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Visited", style: .Default)
        { action in

        })
        presentViewController(ac, animated: true, completion: nil)
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
                        let location = Location(json: subJson)
                        self.locations.append(location)
                        self.mapView.addAnnotation(location)
                    }

                    //self.saveLocations()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func saveLocations()
    {
        let locationsData = NSKeyedArchiver.archivedDataWithRootObject(locations)
        NSUserDefaults.standardUserDefaults().setObject(locationsData, forKey: "Locations")
    }

    ////////////////////////////////////////////////////////////

    func loadLocations()
    {
        if let locationsData = NSUserDefaults.standardUserDefaults().objectForKey("Locations") as? NSData,
            let locationsArray = NSKeyedUnarchiver.unarchiveObjectWithData(locationsData) as? [Location]
        {
            locations = locationsArray
        }
    }
}
