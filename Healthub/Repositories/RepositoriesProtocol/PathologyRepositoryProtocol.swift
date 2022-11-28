//
//  PathologyRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 26/11/22.
//

import Foundation

protocol PathologyRepositoryProcotol: RepositoryAddable, RepositoryDeletable, RepositoryListGettable where T == Pathology
{
   // typealias T = Pathology
}
