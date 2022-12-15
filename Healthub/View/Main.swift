import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @AppStorage("firstAppLaunch") var firstAppLaunch : Bool = true
    @AppStorage("isLogged") var isLogged : Bool = false
    
    var body: some View {
        if(isLogged == false){ WelcomeView() }
        else{
            VStack{
                // Defines the application tab bar
                TabView{
                    TicketsView()
                        .tabItem{ Label("Tickets", systemImage: "ticket.fill") }
                    TherapiesView()
                        .tabItem{ Label("Therapies", systemImage: "pills.fill") }
                    DoctorsGalleryView()
                        .tabItem{ Label("Contacts", systemImage: "person.crop.rectangle.stack.fill") }
                    ProfileView()
                        .tabItem{ Label("Profile", systemImage: "figure.arms.open") }
                }
                // Changes the tint of the tab bar
                .tint(Color("HealthGray3"))
            }
            .sheet(isPresented: $firstAppLaunch) { OnBoardingView() }
        }
    }
}
