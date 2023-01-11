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

protocol ConnectionProviderProtocol: WCSessionDelegate {
    var session: WCSession {get}
    var objectWillChange:PassthroughSubject<Void, Never> {get set}
    var send: [Reservation] {get}
    var sendTherapies: [Therapy] {get}
    var sendContacts: [Contact] {get}
    var sendProfile: [Patient] {get}
    var sendPathologies: [Pathology] {get}
    static var shared: ConnectionProviderProtocol { get }
    var dbHelper: DBHelperProtocol{get}
    
    var received: [Reservation] {get}
    var receivedTherapies: [Therapy] {get}
    var receivedContacts: [Contact] {get}
    var receivedProfile: Patient? {get}
    var receivedPathologies: [Pathology] {get}
    
    func connect()
    
    func sendMessage(message: [String: Any]) -> Void
    func sendWatchMessageTherapies(_ msgData: [Therapy])
    func sendWatchMessageContacts(_ msgData: [Contact])
    func sendWatchMessageProfile(_ msgData: Patient)
    func sendWatchMessagePathologies(_ msgData: [Pathology])

    func sendWatchMessage(_ msgData: [Reservation])
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession)
    
    func sessionDidDeactivate(_ session: WCSession)
    
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data)
    
}
