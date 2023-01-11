//
//  ConnectionProvider.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 24/12/22.
//

import UIKit
import WatchConnectivity
import Combine
import CoreData

class ConnectionProvider: NSObject, ConnectionProviderProtocol {
    
    static let shared: ConnectionProviderProtocol = ConnectionProvider(dbHelper: CoreDataHelper())

    internal let session: WCSession
    var objectWillChange = PassthroughSubject<Void, Never>()
    var send: [Reservation] = []
    var sendTherapies: [Therapy] = []
    var sendContacts: [Contact] = []
    var sendProfile: [Patient] = []
    var sendPathologies: [Pathology] = []
    
    @Published var received: [Reservation] = []{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var receivedTherapies: [Therapy] = []{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var receivedContacts: [Contact] = []{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var receivedProfile: Patient?
    @Published var receivedPathologies: [Pathology] = []
    var lastMessage: CFAbsoluteTime = 0
    internal var dbHelper: DBHelperProtocol
    
    init(session: WCSession = .default, dbHelper: any DBHelperProtocol){
        self.session = session
        self.dbHelper = dbHelper
        super.init()
        self.session.delegate = self
        
        self.session.activate()
        
    }

    
    func connect(){
        guard WCSession.isSupported() else{
            print("WCSession not supported")
            return
        }
        
        self.session.activate()
    }
    
    func sendMessage(message: [String: Any]) -> Void{
        session.sendMessage(message, replyHandler: nil){ (error) in
            print(error.localizedDescription)
        }
    }
    func sendWatchMessageTherapies(_ msgData: [Therapy]){
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            print("Abort data")
            return
            
        }
        
        if(session.isReachable == true){
            NSKeyedArchiver.setClassName("Therapy Object", for: Therapy.self)
            sendTherapies.removeAll()
            for res in msgData{
                sendTherapies.append(res)
            }
            var programData:Data = Data.init()
            
            
            do{
                programData = try NSKeyedArchiver.archivedData(withRootObject: sendTherapies, requiringSecureCoding: false)
            }catch{
                print(error)
            }
                
            print("Sending message: \(Therapy.self) Object")
            
            let message: [String: Any] = ["Type": "Therapies" ,"Data": programData]
            self.session.sendMessage(message, replyHandler: nil){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    func sendWatchMessageContacts(_ msgData: [Contact]){
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            print("Abort data")
            return
            
        }
        
        if(session.isReachable == true){
            NSKeyedArchiver.setClassName("Contact Object", for: Contact.self)
            sendContacts.removeAll()
            for res in msgData{
                sendContacts.append(res)
            }
            var programData:Data = Data.init()
            do{
                programData = try NSKeyedArchiver.archivedData(withRootObject: sendContacts, requiringSecureCoding: false)
            }catch{
                print(error)
            }
                
            print("Sending message: \(Contact.self) Object")
            
            let message: [String: Any] = ["Type": "Contacts","Data": programData]
            self.session.sendMessage(message, replyHandler: nil){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    func sendWatchMessageProfile(_ msgData: Patient) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            print("Abort data")
            return
            
        }
        
        if(session.isReachable == true){
            NSKeyedArchiver.setClassName("Patient Object", for: Patient.self)
            sendProfile.removeAll()
            sendProfile.append(msgData)
            var programData:Data = Data.init()
            do{
                programData = try NSKeyedArchiver.archivedData(withRootObject: sendProfile, requiringSecureCoding: false)
            }catch{
                print(error)
            }
                
            print("Sending message: \(Patient.self) Object")
            
            let message: [String: Any] = ["Type": "Patient","Data": programData]
            self.session.sendMessage(message, replyHandler: nil){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    func sendWatchMessagePathologies(_ msgData: [Pathology]) {}

    func sendWatchMessage(_ msgData: [Reservation]){
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            print("Abort data")
            return
            
        }
        
        if(session.isReachable == true){
            NSKeyedArchiver.setClassName("Reservation Object", for: Reservation.self)
            send.removeAll()
            for res in msgData{
                send.append(res)
            }
            var programData:Data = Data.init()
            do{
                programData = try NSKeyedArchiver.archivedData(withRootObject: send, requiringSecureCoding: false)
            }catch{
                print(error)
            }
                
            print("Sending message: \(Reservation.self) Object")
            
            let message: [String: Any] = ["Type": "Reservations","Data": programData]
            self.session.sendMessage(message, replyHandler: nil){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //code
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //on temporary lose connection
        print("inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //on lose
        print("deactivate")
    }
    
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            
            
            if message["Data"] != nil {
                
                let type = message["Type"] as! String
                let loadedData = message["Data"]
                
                switch type {
                    
                case "Reservations":
                    NSKeyedUnarchiver.setClass(Reservation.self, forClassName: "Reservation Object")
                    
                    do{
                        let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Reservation.self] , from: loadedData as! Data) as? [Reservation]
                        self.received = data!
                    }catch{
                        print(error)
                    }
                case "Therapies":
                    
                   NSKeyedUnarchiver.setClass(Therapy.self, forClassName: "Therapy Object")
                    
                    do{
                        let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Therapy.self] , from: loadedData as! Data) as? [Therapy]
                        self.receivedTherapies = data!
                    }catch{
                        print(error)
                    }
                case "Contacts":
                    NSKeyedUnarchiver.setClass(Contact.self, forClassName: "Contact Object")
                     
                     do{
                         let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Doctor.self] , from: loadedData as! Data) as? [Doctor]
                         self.receivedContacts.removeAll()
                         for d in data!{
                             let entity = NSEntityDescription.entity(forEntityName: "Contact", in: CoreDataHelper
                                .context)!
                             let contact = Contact(entity: entity, insertInto: CoreDataHelper.context)
                             contact.id = d.id
                             contact.name = d.name
                             contact.email = d.email
                             contact.phone = d.phone
                             contact.address = d.address
                             self.receivedContacts.append(contact)
                         }
                         
                         
                     }catch{
                         print(error)
                     }
                    
                case "Patient":
                    
                   NSKeyedUnarchiver.setClass(Patient.self, forClassName: "Patient Object")
                    
                    do{
                        let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Patient.self] , from: loadedData as! Data) as? [Patient]
                        self.receivedProfile = data![0]
                    }catch{
                        print(error)
                    }
                default:
                    print("Something went wrong")
                    
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
           print("Message")
        }
    }
    
}
