import SwiftUI

struct Pathologies: View {
    @EnvironmentObject private var pathologyViewModel: PathologyViewModel
    
    var body: some View {
       
        Group {
            // Empty list placeholder
            if pathologyViewModel.connectivityProvider.receivedPathologies.isEmpty {
                VStack(spacing: 0) {
                    Image("PathologiesPlaceholder")
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
            else {
                List {
                    // Header
                    HStack {
                        Text("Pathologies")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 24, weight: .heavy))
                        Spacer()
                        Image(systemName: "microbe.fill")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .listItemTint(.clear)
                    
                    // Pathologies
                    ForEach(pathologyViewModel.connectivityProvider.receivedPathologies, id: \.self) { pathology in
                        Text(pathology.name.capitalized)
                    }
                }
                .listStyle(.elliptical)
            }
        }
        .navigationTitle("Hub")
    }
}
