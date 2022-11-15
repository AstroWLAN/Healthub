import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("USER DATA")){
                    NavigationLink(destination: AppInformationView()){
                        Label("Pathologies", systemImage: "allergens.fill")
                            .labelStyle(HealthubLabel(labelColor: Color(.systemGray)))
                    }
                }
                Section(header: Text("OTHER")){
                    NavigationLink(destination: AppInformationView()){
                        Label("Information", systemImage: "info.circle.fill")
                            .labelStyle(HealthubLabel(labelColor: Color(.systemGray)))
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .tint(Color(.systemPink))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
