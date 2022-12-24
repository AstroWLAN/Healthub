import SwiftUI

// Fake patient data structure
struct Patient {
    let name: String
    let sex: String
    let dateOfBirth: Date
    let fiscalCode: String
    let height: Int
    let weight: Float
    let phone: String
    let pathologies : [String]
}

struct Profile: View {
    
    @State private var user : Patient = Patient(name: "Dario Crippa", sex: "Male", dateOfBirth: Date(), fiscalCode: "CRPDRA97B09F704M",height: 174, weight: 64, phone: "3393082487",
                                                pathologies: ["AIDS", "Asthma"]
    )
    
    var body: some View {
        
        TabView {
            List {
                Text("Generalities")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Label(user.name, systemImage: "face.smiling.inverse")
                Label(user.fiscalCode, systemImage: "barcode")
                Label(user.phone, systemImage: "phone.fill")
            }
            List {
                Text("Medical Records")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Label(user.sex, systemImage: "person.fill")
                Label(String(user.height) + " cm", systemImage: "ruler.fill")
                Label(String(user.weight) + " kg", systemImage: "scalemass.fill")
                Label(user.dateOfBirth.formatted(.dateTime.day()) +  " " + user.dateOfBirth.formatted(.dateTime.month(.wide)) +  " " + user.dateOfBirth.formatted(.dateTime.year()),
                      systemImage: "calendar")
            }
            List {
                Text("Pathologies")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                ForEach(user.pathologies, id: \.self) { pathology in
                    Text(pathology)
                }
            }
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
