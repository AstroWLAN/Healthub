//
//  PathologyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 26/11/22.
//

import Foundation

protocol PathologyRepositoryProcotol
{
   // typealias T = Pathology
    func add(pathologyName:String, completionHandler: @escaping (Bool?, Error?) -> Void)
    
    func delete(pathologyId:Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    
    func getAll(completionHandler: @escaping ([Pathology]?, Error?) -> Void)
}
