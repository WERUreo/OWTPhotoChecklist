//
//  HistoricLocation.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/19/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class HistoricLocation
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var locationName: String?
    var locationAddress: String?
    var locationDescription: String?
    var locationType: String?
    var locationCoordinates: CLLocationCoordinate2D?

    ////////////////////////////////////////////////////////////
    // MARK: - Initializers
    ////////////////////////////////////////////////////////////

    convenience init(json: JSON)
    {
        let locationName = json["name"].string ?? ""
        let locationAddress = json["address"].string ?? ""
        let locationDescription = json["description"].string ?? ""
        let locationType = json["type"].string ?? ""
        var locationCoordinates = CLLocationCoordinate2D()

        if let latitude = json["location"]["latitude"].double,
           let longitude = json["location"]["longitude"].double
        {
            locationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
        }

        self.init(name: locationName,
                  address: locationAddress,
                  description: locationDescription,
                  type: locationType,
                  coordinates: locationCoordinates)
    }

    ////////////////////////////////////////////////////////////

    init(name: String, address: String, description: String, type: String, coordinates: CLLocationCoordinate2D)
    {
        self.locationName = name
        self.locationAddress = address
        self.locationDescription = description
        self.locationType = type
        self.locationCoordinates = coordinates
    }
}