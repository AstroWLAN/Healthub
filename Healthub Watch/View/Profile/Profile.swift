import SwiftUI

struct Profile: View {
    
    @State private var user: Patient?
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        Group {
            // Empty list placeholder
            if profileViewModel.connectivityProvider.receivedProfile == nil {
                VStack(spacing: 0) {
                    Image("ProfilePlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .opacity(0.5)
                        .padding(.vertical, 20)
                    Capsule()
                        .frame(width: 80, height: 30)
                        .foregroundColor(Color("AstroGray"))
                        .overlay(
                            Text("Empty")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(.lightGray))
                        )
                }
            }
            // Profile
            else {
                List {
                    // Header
                    HStack {
                        Text("Profile")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 24, weight: .heavy))
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 21, weight: .bold))
                    }
                    .listItemTint(.clear)
                    // Generalities
                    Label(profileViewModel.connectivityProvider.receivedProfile!.name, systemImage: "face.smiling.inverse")
                    Label(profileViewModel.connectivityProvider.receivedProfile!.fiscalCode, systemImage: "barcode")
                    Label(profileViewModel.connectivityProvider.receivedProfile!.phone, systemImage: "phone.fill")
                    Label(Gender.element(at: Int(profileViewModel.connectivityProvider.receivedProfile!.sex))!.rawValue.capitalized, systemImage: "person.fill")
                    Label(String(profileViewModel.connectivityProvider.receivedProfile!.height) + " cm", systemImage: "ruler.fill")
                    Label(String(profileViewModel.connectivityProvider.receivedProfile!.weight) + " kg", systemImage: "scalemass.fill")
                    Label(profileViewModel.connectivityProvider.receivedProfile!.dateOfBirth.formatted(.dateTime.day().month(.wide)).capitalized +  " " + profileViewModel.connectivityProvider.receivedProfile!.dateOfBirth.formatted(.dateTime.year()),
                          systemImage: "calendar")
                }
                .listStyle(.elliptical)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            }
        }
        .navigationTitle("Hub")
    }
}
