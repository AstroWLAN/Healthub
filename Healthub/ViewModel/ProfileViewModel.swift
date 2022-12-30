//
//  SettingsViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published private var hasError: Bool = false
  
    @Published var patient: Patient?
    private var userService: any UserRepositoryProtocol
    @Published var isLoading = false
    @Published var name : String = ""
    @Published var gender : Gender = .male
    @Published var height : String = ""
    @Published var weight : String = ""
    @Published var birthday : Date = Date()
    @Published var fiscalCode : String = ""
    @Published var phone : String = ""
    
    init(userService: any UserRepositoryProtocol){
        self.userService = userService
    }
    
    func getPatient(force_reload: Bool = false){
        self.isLoading = true
        userService.getUser(force_reload: force_reload){(patient, error) in
                if let error = error{
                    print(error)
                    self.hasError = true
                }else{
                    self.patient = patient!
                    self.name = patient!.name
                    self.gender = Gender.element(at: Int(patient!.sex))!
                    self.height = String(patient!.height)
                    self.weight = String(patient!.weight)
                    self.birthday = patient!.dateOfBirth
                    self.fiscalCode = patient!.fiscalCode
                    self.phone = patient!.phone
                    self.isLoading = false
                }
                
            }
        
    }
    
    func updatePatient(){
        self.patient?.name = self.name
        self.patient?.sex = Int16(Gender.index(of: self.gender))
        self.patient?.height = Int16(self.height)!
        self.patient?.weight = Float(self.weight)!
        self.patient?.dateOfBirth = self.birthday
        self.patient?.fiscalCode = self.fiscalCode
        self.patient?.phone = self.phone
        
        userService.updateInformation(user: self.patient!){ (success, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.getPatient(force_reload: true
                )
            }
        }
    }
}
    
