//
//  SettingsViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published private var hasError: Bool = false
  
    private var patient: Patient?
    @Published var isLoading = false
    @Published var name : String = ""
    @Published var gender : Genders = .Male
    @Published var height : String = ""
    @Published var weight : String = ""
    @Published var birthday : Date = Date()
    @Published var fiscalCode : String = ""
    @Published var phone : String = ""
    
    
    func getPatient(){
        self.isLoading = true
        UserService.shared.getUser(){(patient, error) in
            if let error = error{
                print(error)
                self.hasError = true
            }else{
                self.patient = patient!
                self.name = patient!.name
                self.gender = patient!.sex
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
        self.patient?.sex = self.gender
        self.patient?.height = Int(self.height)!
        self.patient?.weight = Float(self.weight)!
        self.patient?.dateOfBirth = self.birthday
        self.patient?.fiscalCode = self.fiscalCode
        self.patient?.phone = self.phone
        
        UserService.shared.updateInformation(user: self.patient!){ (success, error) in
            
        }
    }
}
    
