import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    @EnvironmentObject private var contactViewModel : ContactViewModel
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    
    @AppStorage("firstAppLaunch") var firstAppLaunch : Bool = true
    @AppStorage("isLogged") var isLogged : Bool = false
    
    var body: some View {
        
        if(isLogged == false){ WelcomeView() }
        else {
            VStack{
                // Defines the application tab bar
                TabView{
                    TicketsView()
                        .tabItem{ Label("Tickets", systemImage: "ticket.fill") }
                    TherapiesView()
                        .tabItem{ Label("Therapies", systemImage: "pills.fill") }
                    DoctorsView()
                        .tabItem{ Label("Contacts", systemImage: "person.crop.rectangle.stack.fill") }
                    ProfileView()
                        .tabItem{ Label("Profile", systemImage: "figure.arms.open") }
                }
                // Changes the tint of the tab bar
                .tint(Color("AstroGray"))
            }
            .onAppear(perform: {
                ticketViewModel.fetchTickets(force_reload: false)
                therapyViewModel.fetchTherapies(force_reload: false)
                contactViewModel.fetchContacts(force_reload: false)
                profileViewModel.getPatient(force_reload: false)
                pathologiesViewModel.fetchPathologies(force_reload: false)
                
            })
            .sheet(isPresented: $firstAppLaunch) { OnBoardingView() }
        }
    }
}
