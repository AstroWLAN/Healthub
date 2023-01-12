//
//  WatchubApp.swift
//  Watchub Watch App
//
//  Created by Dario Crippa on 21/12/22.
//

import SwiftUI

@main
struct Watchub_Watch_AppApp: App {
    @StateObject var ticketViewModel = TicketViewModel(reservationsRepository: ReservationsRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider.shared)
    @StateObject var therapyViewModel = TherapyViewModel(therapyRepository: TherapyRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider:  ConnectionProvider.shared)
    @StateObject var profileViewModel = ProfileViewModel(userRepository: UserRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider:  ConnectionProvider.shared)
    @StateObject var contactViewModel = ContactViewModel(contactRepository: ContactRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider:  ConnectionProvider.shared)
    @StateObject var pathologyViewModel = PathologyViewModel(pathologyRepository: PathologyRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider:  ConnectionProvider.shared)
    var body: some Scene {
        WindowGroup {
            WatchMain()
              .environmentObject(ticketViewModel)
              .environmentObject(therapyViewModel)
              .environmentObject(profileViewModel)
              .environmentObject(contactViewModel)
              .environmentObject(pathologyViewModel)
        }
    }
    
}
