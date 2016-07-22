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
import SwiftyJSON
import Firebase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
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

        if NSUserDefaults.standardUserDefaults().objectForKey("Locations") == nil
        {
            retrieveLocations()
        }
        else
        {
            loadLocations()
        }

        GeoJSONService.sharedInstance.fetch()
        { response in
            if let polygons = response as? [MKPolygon]
            {
                self.mapView.addOverlays(polygons)
            }
        }
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

            (annotationView as! MKPinAnnotationView).pinTintColor = (annotation as! Location).visited ? UIColor.greenColor() : UIColor.redColor()

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
            if let found = self.locations.indexOf({$0.title == locationName})
            {
                self.locations[found].visited = true
                self.saveLocations()
                (view as! MKPinAnnotationView).pinTintColor = UIColor.greenColor()
            }
        })
        presentViewController(ac, animated: true, completion: nil)
    }

    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if let polygon = overlay as? MKPolygon
        {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.strokeColor = UIColor.cfoColor()
            renderer.fillColor = UIColor.cfoColor(alpha: 0.2)
            renderer.lineWidth = 1.0

            return renderer
        }

        return MKPolygonRenderer()
    }

    ////////////////////////////////////////////////////////////

    func retrieveLocations()
    {
        DataService.sharedInstance.REF_LOCATIONS.observeEventType(.Value, withBlock:
        { snapshot in
            self.locations = []
            print(snapshot)

            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let locationDict = snap.value as? [String : AnyObject]
                    {
                        print(locationDict)
                        let location = Location(json: JSON(locationDict))
                        self.locations.append(location)
                        self.mapView.addAnnotation(location)
                    }
                }

                self.saveLocations()
            }
        })
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
            for location in locations
            {
                mapView.addAnnotation(location)
            }
        }
    }
}
