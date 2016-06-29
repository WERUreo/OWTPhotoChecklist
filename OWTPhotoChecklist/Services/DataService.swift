//
//  DataService.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 6/9/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

struct DataService
{
    static let sharedInstance = DataService()

    ////////////////////////////////////////////////////////////

    private var _REF_BASE = URL_BASE
    private var _REF_LOCATIONS = URL_BASE.child("historic-locations")

    ////////////////////////////////////////////////////////////

    var REF_BASE: FIRDatabaseReference
    {
        return _REF_BASE
    }

    var REF_LOCATIONS: FIRDatabaseReference
    {
        return _REF_LOCATIONS
    }
}