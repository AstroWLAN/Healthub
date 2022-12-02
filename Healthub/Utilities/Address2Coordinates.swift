//
//  Address2Coordinates.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 02/12/22.
//

import Foundation
import CoreLocation

struct Address2Coordinates{
    
    static func translate(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?, Error?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil, error)
                return
            }
            completion(location, nil)
        }
    }
    
}
