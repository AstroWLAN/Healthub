//
//  TherapyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

protocol TherapyRepositoryProtocol{
    func getDrugList(query: String,  completionHandler: @escaping ([Drug]?, Error?) -> Void)
    func getAll(force_reload: Bool, completionHandler: @escaping ([Therapy]?, Error?) -> Void)
    func createTherapy(drug_ids: [Int16], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void)
    func removeTherapy(therapy_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    
}
