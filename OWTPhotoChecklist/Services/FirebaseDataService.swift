//
//  FirebaseDataService.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/18/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

struct FirebaseDataService
{
    let databaseRef = FIRDatabase.database().reference()

    ////////////////////////////////////////////////////////////

    func getLocations(completion: (locations: [HistoricLocation]) -> Void)
    {
        let ormondLocationsRef = databaseRef.child("ormond-beach")

        ormondLocationsRef.observeEventType(.Value, withBlock:
        { snapshot in
            var locations = [HistoricLocation]()

            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    if let locationDict = snap.value as? [String : AnyObject]
                    {
                        let locationJSON = JSON(locationDict)
                        let location = HistoricLocation(json: locationJSON)
                        locations.append(location)
                    }
                }
            }

            completion(locations: locations)
        })
    }

    ////////////////////////////////////////////////////////////

    func saveLocation(location: HistoricLocation)
    {
        let ormondLocationsRef = databaseRef.child("ormond-beach")

        let key = ormondLocationsRef.childByAutoId().key
        ormondLocationsRef.child("\(key)/name").setValue(location.locationName)
        ormondLocationsRef.child("\(key)/address").setValue(location.locationAddress)
        ormondLocationsRef.child("\(key)/description").setValue(location.locationDescription)
        ormondLocationsRef.child("\(key)/type").setValue(location.locationType)
        ormondLocationsRef.child("\(key)/location/latitude").setValue(location.locationCoordinates?.latitude)
        ormondLocationsRef.child("\(key)/location/longitude").setValue(location.locationCoordinates?.longitude)
    }
}