//
//  ConnectionProvider.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 24/12/22.
//

import UIKit
import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate {
    
    private let session: WCSession
    var send: [Reservation] = []
    @Published var received: [Reservation] = []
    @Published var receivedTherapies: [Therapy] = []
    @Published var receivedDoctors: [Doctor] = []
    @Published var receivedProfile: Patient?
    @Published var receivedPathologies: [Pathology] = []
    var lastMessage: CFAbsoluteTime = 0
    
    init(session: WCSession = .default){
        self.session = session
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
        print(123)
        print(message)
        session.sendMessage(message, replyHandler: nil){ (error) in
            print(error.localizedDescription)
        }
    }
    func sendWatchMessageTherapies(_msgData: [Therapy]){}
    func sendWatchMessageDoctors(_msgData: [Doctor]){}
    func sendWatchMessageProfile(_msgData: Patient) {}
    func sendWatchMessagePathologies(_msgData: [Pathology]) {}

    func sendWatchMessage(_ msgData: [Reservation]){
        print("Sending Data")
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            print("Abort data")
            return
            
        }
        
        if(session.isReachable == true){
            print("Reachable")
            print(msgData.count)
            NSKeyedArchiver.setClassName("Reservation Object", for: Reservation.self)
            send.removeAll()
            for res in msgData{
                send.append(res)
            }
            print(1)
            var programData:Data = Data.init()
            do{
                programData = try NSKeyedArchiver.archivedData(withRootObject: send, requiringSecureCoding: false)
            }catch{
                print(error)
            }
                
            print(2)
            print("Sending message: \(Reservation.self) Object")
            
            let message: [String: Any] = ["Type": "Reservation" ,"Data": programData]
            self.session.sendMessage(message, replyHandler: nil){ (error) in
                print(error.localizedDescription)
            }
            print("End1")
        }
        print("End")
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
        //on lose connectoin
        print("deactivate")
    }
    
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("entered didreceive")
            
            if message["Data"] != nil {
                let loadedData = message["Data"]
                print(message)
                
                NSKeyedUnarchiver.setClass(Reservation.self, forClassName: "Reservation Object")
                
                do{
                    
                    let data = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Reservation.self] , from: loadedData as! Data) as? [Reservation]
                    print(data!)
                    self.received = data!
                }catch{
                    print(error)
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
