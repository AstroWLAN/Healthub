import SwiftUI

struct Pathologies: View {
    @EnvironmentObject private var pathologyViewModel: PathologyViewModel
    
    var body: some View {
        
        // Tutto è commentato perché si basa sulla ricezione delle patologie come nei ticket
        // Nel foreach semplicemente stampare il nome della pathology 
        
    
        if pathologyViewModel.connectivityProvider.receivedPathologies.isEmpty {
            // Pathologies Placeholder
            Text("Nothing to show")
        }
        else {
            List {
                ForEach(pathologyViewModel.connectivityProvider.receivedPathologies, id: \.self) { pathology in
                    Text(pathology.name)
                }
            }
            .listStyle(.elliptical)
            .onAppear(perform: {
               // Connectivity
            })
        }
    }
}
