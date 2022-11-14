import SwiftUI

struct MainView: View {
    
    @AppStorage("firstAppLaunch") var firstAppLaunch : Bool = true
    
    var body: some View {
        // Tab Bar
        TabView{
            ScheduleView()
                .tabItem{ Label("Schedule", systemImage: "clipboard.fill") }
            TherapiesView()
                .tabItem{ Label("Therapies", systemImage: "pills.fill") }
            ContactsView()
                .tabItem{ Label("Contacts", systemImage: "person.crop.rectangle.stack.fill") }
            SettingsView()
                .tabItem{ Label("Settings", systemImage: "gear") }
        }
        // Changes the color of the selected item in the Tab Bar
        .tint(Color("HealthGray3"))
        .sheet(isPresented: $firstAppLaunch) {
            OnBoardingView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
