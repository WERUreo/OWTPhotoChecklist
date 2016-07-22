//
//  GeoJSONService.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/6/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import Alamofire
import GeoJSONSerialization

struct GeoJSONService
{
    static let sharedInstance = GeoJSONService()

    func fetch(geoPoints completion: [AnyObject] -> Void)
    {
        Alamofire.request(.GET, "https://raw.githubusercontent.com/WERUreo/GISData/master/Orange_County/City_of_Orlando/OrlandoHistoricDistricts.geojson").responseJSON
        { response in
            if let resultData = response.result.value as? [NSObject: AnyObject]
            {
                do
                {
                    let shape = try GeoJSONSerialization.shapesFromGeoJSONFeatureCollection(resultData)
                    completion(shape)
                }
                catch
                {
                    print("GeoJSON error")
                }
            }
        }
    }
}