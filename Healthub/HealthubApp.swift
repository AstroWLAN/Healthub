import SwiftUI

/// ** EXTENSIONS **

// Adds the capability of removing the view from a view stack
extension View {
    @ViewBuilder func isVisible(_ remove: Bool = false) -> some View {
        if remove { self }
        else { }
    }
}

// Removes the back button text in the Navigation Stack
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

@main
struct HealthubApp: App {
    @StateObject var loginViewModel = LoginViewModel(userRepository: UserRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()))
    @StateObject var signUpViewModel = SignUpViewModel(userRepository: UserRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()))
    @StateObject var pathologiesViewModel = PathologyViewModel(pathologiesRepository: PathologyRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider(dbHelper:  CoreDataHelper()))
    @StateObject var settingsViewModel = ProfileViewModel(userService: UserRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider(dbHelper:  CoreDataHelper()))
    @StateObject var ticketViewModel = TicketViewModel(reservationsRepository: ReservationsRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider(dbHelper:  CoreDataHelper()))
    @StateObject var therapyViewModel = TherapyViewModel(therapyRepository: TherapyRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider(dbHelper:  CoreDataHelper()))
    @StateObject var contactViewModel = ContactViewModel(contactRepository: ContactRepository(client: API.Client(dbHelper: CoreDataHelper()), dbHelper: CoreDataHelper()), connectivityProvider: ConnectionProvider(dbHelper:  CoreDataHelper()))
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(loginViewModel)
                .environmentObject(signUpViewModel)
                .environmentObject(pathologiesViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(ticketViewModel)
                .environmentObject(therapyViewModel)
                .environmentObject(contactViewModel)
        }
    }
}
