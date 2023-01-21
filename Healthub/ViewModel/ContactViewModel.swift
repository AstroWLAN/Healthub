//
//  ContactsViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import Combine

class ContactViewModel: ObservableObject{
    private let contactRepository: any ContactRepositoryProtocol
    private(set) var connectivityProvider: any ConnectionProviderProtocol
    @Published var doctors: [Doctor] = []{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var contacts: [Contact] = []{
        willSet {
            objectWillChange.send()
        }
    }
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    init(contactRepository: any ContactRepositoryProtocol, connectivityProvider: any ConnectionProviderProtocol ) {
        self.contactRepository = contactRepository
        self.connectivityProvider = connectivityProvider
        self.connectivityProvider.connect()
    }
    
    func getDoctorList(){
        
        contactRepository.getDoctorList(){ (doctors, error) in
            if let error = error {
                print(error)
            }else{
                self.doctors = doctors!
            }
            
        }
    }
    
    func fetchContacts(force_reload: Bool){
        contactRepository.getAll(force_reload: force_reload){(contacts, error) in
            if let error = error {
                print(error)
            }else{
                self.contacts = contacts!
                self.connectivityProvider.connect()
                self.connectivityProvider.sendWatchMessageContacts(contacts!)
            }
            
        }
    }
    
    func deleteContact(doctor_id : Int){
        
        self.contacts = self.contacts.filter{ $0.id != doctor_id}
        contactRepository.removeContact(doctor_id: doctor_id){(success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let success = success {
                if(success == false){
                    print("Problem in removing the contact")
                }
            }
            
        }
    }
    
    func addContact(doctor_id : Int){
        contactRepository.addContact(doctor_id: doctor_id){(success, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let success = success {
                    if(success == false){
                        print("Problem in adding the contact")
                    }else{
                        self.fetchContacts(force_reload: true)
                    }
                }
        }
    }
    
}
