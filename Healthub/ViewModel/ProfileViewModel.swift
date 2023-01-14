//
//  SettingsViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published private var hasError: Bool = false
    private(set) var connectivityProvider: any ConnectionProviderProtocol
  
    @Published var patient: Patient?
    private var userRepository: any UserRepositoryProtocol
    @Published var isLoading = false
    @Published var name : String = ""
    @Published var gender : Gender = .male
    @Published var height : String = ""
    @Published var weight : String = ""
    @Published var birthday : Date = Date()
    @Published var fiscalCode : String = ""
    @Published var phone : String = ""
    
    init(userRepository: any UserRepositoryProtocol, connectivityProvider: any ConnectionProviderProtocol){
        self.userRepository = userRepository
        self.connectivityProvider = connectivityProvider
        self.connectivityProvider.connect()
        
    }
    
    func getPatient(force_reload: Bool = false){
        self.isLoading = true
        userRepository.getUser(force_reload: force_reload){(patient, error) in
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
                    self.connectivityProvider.connect()
                    self.connectivityProvider.sendWatchMessageProfile(patient!)
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
        
        userRepository.updateInformation(user: self.patient!){ (success, error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
    
