//
//  ContactsViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

class ContactsViewModel: ObservableObject{
    private let contactRepository: any ContactRepositoryProtocol
    
    init(contactRepository: any ContactRepositoryProtocol) {
        self.contactRepository = contactRepository
    }
}
