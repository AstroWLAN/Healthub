//
//  TherapyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

protocol TherapyRepositoryProtocol{
    func getDrugList(query: String,  completionHandler: @escaping ([Drug]?, Error?) -> Void)
    func getAll(completionHandler: @escaping ([Therapy]?, Error?) -> Void)
    func createTherapy(drug_ids: [Int16], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void)
    /*func addTherapy()
    func deleteTherapy()*/
    
}
