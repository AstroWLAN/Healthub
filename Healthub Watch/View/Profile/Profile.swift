import SwiftUI

// Fake patient data structure
/*struct Patient {
    let name: String
    let sex: String
    let dateOfBirth: Date
    let fiscalCode: String
    let height: Int
    let weight: Float
    let phone: String
    let pathologies : [String]
}*/

struct Profile: View {
    
    @State private var user: Patient?
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        
        TabView {
            List {
                Text("Generalities")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Label(profileViewModel.connectivityProvider.receivedProfile!.name, systemImage: "face.smiling.inverse")
                Label(profileViewModel.connectivityProvider.receivedProfile!.fiscalCode, systemImage: "barcode")
                Label(profileViewModel.connectivityProvider.receivedProfile!.phone, systemImage: "phone.fill")
            }
            List {
                Text("Medical Records")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Label(Gender.element(at: Int(profileViewModel.connectivityProvider.receivedProfile!.sex))!.rawValue, systemImage: "person.fill")
                Label(String(profileViewModel.connectivityProvider.receivedProfile!.height) + " cm", systemImage: "ruler.fill")
                Label(String(profileViewModel.connectivityProvider.receivedProfile!.weight) + " kg", systemImage: "scalemass.fill")
                Label(profileViewModel.connectivityProvider.receivedProfile!.dateOfBirth.formatted(.dateTime.day()) +  " " + profileViewModel.connectivityProvider.receivedProfile!.dateOfBirth.formatted(.dateTime.month(.wide)) +  " " + profileViewModel.connectivityProvider.receivedProfile!.dateOfBirth.formatted(.dateTime.year()),
                      systemImage: "calendar")
            } 
            /*List {
                Text("Pathologies")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
               /* ForEach(user!.pathologies, id: \.self) { pathology in
                    Text("pathology")
                }*/
            }*/
        }
        .listStyle(.elliptical)
        .lineLimit(1)
        .minimumScaleFactor(0.2)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
