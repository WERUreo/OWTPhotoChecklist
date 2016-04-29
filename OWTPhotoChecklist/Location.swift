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

class Location : MKPointAnnotation
{
    var visited = false
    
    init(json: JSON)
    {
        super.init()

        self.title = json["name"].stringValue
        self.subtitle = json["address"].stringValue
        self.coordinate = CLLocationCoordinate2DMake(json["location"]["latitude"].doubleValue, json["location"]["longitude"].doubleValue)
    }
}
