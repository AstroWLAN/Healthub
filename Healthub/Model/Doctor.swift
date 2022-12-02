//
//  Doctor.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import CoreLocation
struct Doctor: Hashable{
    private(set) var id: Int
    private(set) var name: String
    private(set) var address: String
  
   /* func getCoordinates(completion: @escaping (_ location: CLLocationCoordinate2D?, Error?)-> Void){
        Address2Coordinates.translate(from: self.address){ (coordinates, error) in
            if let coordinates = coordinates{
                completion(coordinates, nil)
            }else{
                completion(nil, error)
            }
            
        }
    }*/
}
