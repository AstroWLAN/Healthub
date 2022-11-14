import SwiftUI

struct MainView: View {
    var body: some View {
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
        // Changes the color of the selected item
        .tint(Color("HealthGray3"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
