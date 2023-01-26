import SwiftUI

struct Doctors: View {
    
    @EnvironmentObject private var contactViewModel: ContactViewModel
    
    var body: some View {
        Group {
            // Empty list placeholder
            if contactViewModel.connectivityProvider.receivedContacts.isEmpty {
                VStack(spacing: 0) {
                    Image("DoctorsPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
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
            else {
                List {
                    // Header
                    HStack {
                        Text("Contacts")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 24, weight: .heavy))
                        Spacer()
                        Image(systemName: "stethoscope")
                            .font(.system(size: 21, weight: .bold))
                    }
                    .listItemTint(.clear)
                    // Doctors
                    ForEach(contactViewModel.connectivityProvider.receivedContacts, id: \.self) { doctor in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(doctor.name!)
                                .font(.system(size: 17, weight: .regular))
                            Text(doctor.address!.capitalized)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            Text(doctor.email!)
                                .font(.system(size: 15))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .listStyle(.elliptical)
            }
        }
        .navigationTitle("Hub")
    }
}
