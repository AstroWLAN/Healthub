import SwiftUI

/*struct Doctor: Hashable {
    let name: String
    let address: String
}*/


struct Doctors: View {
    
    @EnvironmentObject private var contactViewModel: ContactViewModel

    
    var body: some View {
        
            if contactViewModel.connectivityProvider.receivedContacts.isEmpty {
                // Doctors Placeholder
                Text("Nothing to show here")
            }
            else {
                List {
                ForEach(contactViewModel.connectivityProvider.receivedContacts, id: \.self) { doctor in
                    VStack(alignment: .leading) {
                        Text(doctor.name!)
                            .font(.system(size: 17, weight: .semibold))
                        Text(doctor.address!)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                }
                .listStyle(.elliptical)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            }
        
    }
}

struct Doctors_Previews: PreviewProvider {
    static var previews: some View {
        Doctors()
    }
}
