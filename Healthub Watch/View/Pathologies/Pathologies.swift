import SwiftUI

struct Pathologies: View {
    var body: some View {
        
        Text("Shut errors") // Remove!
        
        // Tutto è commentato perché si basa sulla ricezione delle patologie come nei ticket
        // Nel foreach semplicemente stampare il nome della pathology 
        
        /*
        if .connectivityProvider.received.isEmpty {
            // Pathologies Placeholder
        }
        else {
            List {
                ForEach( /* received pathologies */ , id: \.self) { pathology in
                    Text(pathology)
                }
            }
            .listStyle(.elliptical)
            .onAppear(perform: {
               // Connectivity
            })
        }
        */
    }
}
