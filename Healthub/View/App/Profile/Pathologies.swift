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
                    List {
                        Section {
                            HStack(spacing: 0) {
                                Label(String(), systemImage: "microbe.fill")
                                TextField("Pathology Name", text: $newPathology)
                                    .onSubmit { insertPathology() }
                                Spacer()
                                ZStack {
                                    Circle()
                                        .frame(height: 20)
                                        .opacity(0.2)
                                    Image(systemName: "exclamationmark")
                                        .font(.system(size: 10, weight: .bold))
                                    
                                }
                                .foregroundColor(Color(.systemRed))
                                .opacity(badPathologyName ? 1 : 0)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .labelStyle(Cubic(glyphBackgroundColor: Color("AstroRed")))
                        
                        Section(header: Text("Pathologies")) {
                            if pathologiesViewModel.pathologies.isEmpty {
                                Label("The User is Perfectly Healthy", systemImage: "heart.fill")
                                    .labelStyle(Cubic(glyphBackgroundColor: Color(.systemGreen)))
                            }
                            else {
                                ForEach(Array(pathologiesViewModel.pathologies.enumerated()), id:\.element) { index,pathology in
                                    Label(pathology.name.capitalized, systemImage: "microbe.fill")
                                        .labelStyle(Cubic())
                                        .swipeActions {
                                            Button(
                                                role: .destructive,
                                                action: { pathologiesViewModel.removePathology(at: index) },
                                                label: { Image(systemName: "trash.fill") }
                                            )
                                        }
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
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
