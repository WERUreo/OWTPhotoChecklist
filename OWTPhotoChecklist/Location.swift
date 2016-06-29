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

class Location : MKPointAnnotation, NSCoding
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    var visited = false

    ////////////////////////////////////////////////////////////
    // MARK: - Initializers
    ////////////////////////////////////////////////////////////

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, visited: Bool = false)
    {
        super.init()

        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.visited = visited
    }

    ////////////////////////////////////////////////////////////

    convenience init(json: JSON)
    {
        self.init(title: json["name"].stringValue,
                  subtitle: json["address"].stringValue,
                  coordinate: CLLocationCoordinate2DMake(json["location"]["latitude"].doubleValue, json["location"]["longitude"].doubleValue))
    }

    ////////////////////////////////////////////////////////////
    // MARK: - NSCoding
    ////////////////////////////////////////////////////////////

    required convenience init?(coder decoder: NSCoder)
    {
        guard let title = decoder.decodeObjectForKey("title") as? String,
            let subtitle = decoder.decodeObjectForKey("subtitle") as? String
        else
        {
            return nil
        }

        let latitude = decoder.decodeDoubleForKey("latitude")
        let longitude = decoder.decodeDoubleForKey("longitude")
        let visited = decoder.decodeBoolForKey("visited")

        self.init(title: title,
                  subtitle: subtitle,
                  coordinate: CLLocationCoordinate2DMake(latitude, longitude),
                  visited: visited)
    }

    ////////////////////////////////////////////////////////////

    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.subtitle, forKey: "subtitle")
        coder.encodeDouble(self.coordinate.latitude, forKey: "latitude")
        coder.encodeDouble(self.coordinate.longitude, forKey: "longitude")
        coder.encodeBool(self.visited, forKey: "visited")
    }
}
