import SwiftUI



struct MainView: View {
    
    @AppStorage("firstAppLaunch") var firstAppLaunch : Bool = true
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @AppStorage("isLogged") var isLogged : Bool = false
    
    var body: some View {
        if(isLogged == false){
            LoginView()
        }else{
            VStack{
                TabView{
                    TicketGalleryView()
                        .tabItem{
                            Label("Tickets", systemImage: "ticket.fill")
                        }
                    TherapiesView()
                        .tabItem{
                            Label("Therapies", systemImage: "pills.fill")
                        }
                    ContactsView()
                        .tabItem{
                            Label("Contacts", systemImage: "person.crop.rectangle.stack.fill")
                        }
                    SettingsView()
                        .tabItem{
                            Label("Settings", systemImage: "gear")
                        }
                }
                // Changes the color of the selected item
                .tint(Color("HealthGray3"))
            }.sheet(isPresented: $firstAppLaunch) {
                OnBoardingView()
            }
            /// **FIRST APP USAGE**
            // Displays an OnBoarding sheet where the user can see the main features of the app
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
