//
//  OrmondTourVC.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/18/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import MapKit

class OrmondTourVC: UIViewController, UISearchBarDelegate, MKMapViewDelegate
{
    ////////////////////////////////////////////////////////////
    // MARK: - IBOutlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var mapView: MKMapView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    lazy var locations = [HistoricLocation]()
    lazy var dataService = FirebaseDataService()

    ////////////////////////////////////////////////////////////
    // MARK: - View Controller Life Cycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //self.mapView.delegate = self

        // Init the zoom level
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.285849, longitude: -81.055624)
        let mapRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        self.mapView.setRegion(mapRegion, animated: true)    // animate the zoom
        //self.mapView.mapType = .Hybrid

        dataService.getLocations()
        { locations in
            self.locations = locations
            self.mapView.removeAnnotations(self.mapView.annotations)
            let locationAnnotations = self.locations.map
            {
                return OrmondAnnotation(location: $0)
            }
            self.mapView.addAnnotations(locationAnnotations)
        }

        GeoJSONService.sharedInstance.fetch("https://raw.githubusercontent.com/WERUreo/GISData/master/Volusia_County/City_of_Ormond_Beach/OrmondBeachHistoricDistrict.geojson")
        { response in
            if let polygons = response as? [MKPolygon]
            {
                print(polygons.count)
                self.mapView.addOverlays(polygons)
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - IBActions
    ////////////////////////////////////////////////////////////


    ////////////////////////////////////////////////////////////
    // MARK: - MKMapViewDelegate
    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let identifier = "OrmondLocation"

        if annotation.isKindOfClass(OrmondAnnotation.self)
        {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil
            {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                let button = UIButton(type: .DetailDisclosure)
                annotationView?.rightCalloutAccessoryView = button
            }
            else
            {
                annotationView?.annotation = annotation
            }
        }
        return MKAnnotationView()
    }

    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        // TODO:
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
}
