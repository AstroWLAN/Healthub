//
//  MockConnectivity.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import Foundation
import Combine
@testable import Healthub
import WatchConnectivity

class MockConnectivity: NSObject, Healthub.ConnectionProviderProtocol{
    var session: WCSession
    
    var objectWillChange: PassthroughSubject<Void, Never>
    
    var send: [Healthub.Reservation] = []
    
    var sendTherapies: [Healthub.Therapy] = []
    
    var sendContacts: [Healthub.Contact] = []
    
    var sendProfile: [Healthub.Patient] = []
    
    var sendPathologies: [Healthub.Pathology] = []
    
    static var shared: Healthub.ConnectionProviderProtocol = MockConnectivity(dbHelper: MockDBHelper())
    
    var received: [Healthub.Reservation] = []
    
    var receivedTherapies: [Healthub.Therapy] = []
    
    var receivedContacts: [Healthub.Contact] = []
    
    var receivedProfile: Healthub.Patient?
    
    var receivedPathologies: [Healthub.Pathology] = []
    
    internal var dbHelper: DBHelperProtocol
    
    init(session: WCSession = .default, dbHelper: DBHelperProtocol){
        self.session = session
        self.objectWillChange = PassthroughSubject<Void, Never>()
        self.dbHelper = dbHelper
        super.init()
        self.session.delegate = self
        
        self.session.activate()
        
    }
    
    func connect() {
        
    }
    
    func sendMessage(message: [String : Any]) {
        
    }
    
    func sendWatchMessageTherapies(_ msgData: [Healthub.Therapy]) {
        
    }
    
    func sendWatchMessageContacts(_ msgData: [Healthub.Contact]) {
        
    }
    
    func sendWatchMessageProfile(_ msgData: Healthub.Patient) {
        
    }
    
    func sendWatchMessagePathologies(_ msgData: [Healthub.Pathology]) {
        
    }
    
    func sendWatchMessage(_ msgData: [Healthub.Reservation]) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
    }
    
}
