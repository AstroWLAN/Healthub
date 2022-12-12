//
//  TherapyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

protocol TherapyRepositoryProtocol{
    func getDrugList(query: String,  completionHandler: @escaping ([Drug]?, Error?) -> Void)
    func getAll(completionHandler: @escaping (Bool?, Error?) -> Void)
    /*func addTherapy()
    func deleteTherapy()*/
    
}
