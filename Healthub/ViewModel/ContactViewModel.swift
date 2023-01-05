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
    @Published var doctors: [Doctor] = []
    @Published var contacts: [Doctor] = []{
        willSet {
            objectWillChange.send()
        }
    }
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    init(contactRepository: any ContactRepositoryProtocol) {
        self.contactRepository = contactRepository
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
    
    func fetchContacts(){
        contactRepository.getAll(){(contacts, error) in
            if let error = error {
                print(error)
            }else{
                self.contacts = contacts!
            }
            
        }
    }
    
    func deleteContact(doctor_id : Int){
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
                    }
                }
        }
    }
    
}
