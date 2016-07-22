//
//  OrmondAnnotation.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/20/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import MapKit

class OrmondAnnotation: NSObject, MKAnnotation
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let ormondBeachCityHall = CLLocationCoordinate2DMake(29.285151, -81.055990)

    ////////////////////////////////////////////////////////////
    // MARK: - Initializers
    ////////////////////////////////////////////////////////////

    init(location: HistoricLocation)
    {
        self.title = location.locationName ?? ""
        self.subtitle = location.locationAddress ?? ""
        if let coordinate = location.locationCoordinates
        {
            self.coordinate = coordinate
        }
        else
        {
            self.coordinate = ormondBeachCityHall
        }
    }
}
