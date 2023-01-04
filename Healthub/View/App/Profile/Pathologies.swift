import SwiftUI

private enum FocusableObject { case insertion }
struct PathologiesView: View {
    
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var newPathology : String = String()
    @State private var badPathologyName : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if pathologiesViewModel.isLoadingPathologies {
                    VStack(spacing: 10) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color(.systemGray))
                        Text("Loading Pathologies")
                            .font(.system(size: 15,weight: .medium))
                            .foregroundColor(Color(.systemGray2))
                    }
                }
                else {
                    
                }
            }
            .navigationBarTitle("Pathologies")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Fetches the pathologies list
        .onAppear(perform: { pathologiesViewModel.fetchPathologies() })
        // Avoids list glitch when the keyboard appears
        .ignoresSafeArea(.keyboard)
    }
    
    // Inserts a new pathology in the list
    private func insertPathology() {
        // Checks if the user has been typed at least on letter and if the inserted pathology already exists
        guard newPathology.count > 0,
              !pathologiesViewModel.pathologies.contains(where: { $0.name == newPathology })
        else {
            // Displays a warning mark if something went wrong
            withAnimation{ badPathologyName = true }
            return
        }
        withAnimation{ pathologiesViewModel.addPathology(pathology: newPathology) }
        newPathology = String()
        withAnimation { badPathologyName = false }
    }
}
