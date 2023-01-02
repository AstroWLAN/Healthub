//
//  WatchubApp.swift
//  Watchub Watch App
//
//  Created by Dario Crippa on 21/12/22.
//

import SwiftUI

@main
struct Watchub_Watch_AppApp: App {
    @StateObject var ticketViewModel = TicketViewModel(reservationsRepository: ReservationsRepository(client: API.Client()), connectivityProvider: ConnectionProvider.shared)
    @StateObject var therapyViewModel = TherapyViewModel(therapyRepository: TherapyRepository(client: API.Client()), connectivityProvider: ConnectionProvider.shared)
    @StateObject var profileViewModel = ProfileViewModel(userService: UserRepository(client: API.Client()), connectivityProvider: ConnectionProvider.shared)
    var body: some Scene {
        WindowGroup {
            WatchMain()
              .environmentObject(ticketViewModel)
              .environmentObject(therapyViewModel)
              .environmentObject(profileViewModel)
        }
    }
    
}
