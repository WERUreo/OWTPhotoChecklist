//
//  DataService.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 6/9/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct DataService
{
    static let sharedInstance = DataService()
    private let rootRef = FIRDatabase.database().reference()

    ////////////////////////////////////////////////////////////
/*
    func retrieveLocations(completion: [Location] -> Void)
    {
        let locationsURLString = "https://brigades.opendatanetwork.com/resource/hzkr-id6u.json"
        var locations = [Location]()

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
                            locations.append(location)
                        }

                        self.saveLocations()
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    } */
}