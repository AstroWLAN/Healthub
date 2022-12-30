//
//  PathologyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 26/11/22.
//

import Foundation

protocol PathologyRepositoryProcotol
{
    func add(pathologyName:String, completionHandler: @escaping (Bool?, Error?) -> Void)
    func delete(pathologyId:Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getAll(force_reload: Bool,completionHandler: @escaping ([Pathology]?, Error?) -> Void)
}
