//
//  Location.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 4/29/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import MapKit

class Location
{
    var title: String
    var address: String
    var description: String?
    var location: CLLocationCoordinate2D

    init(json: JSON)
    {
        title = json["name"].stringValue
        address = json["address"].stringValue
        location = CLLocationCoordinate2DMake(json["location"]["latitude"].doubleValue, json["location"]["longitude"].doubleValue)

        if let jsonDescription = json["description"].string
        {
            description = jsonDescription
        }
    }
}
