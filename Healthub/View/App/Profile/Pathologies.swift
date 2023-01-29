import SwiftUI
import SPIndicator

private enum FocusableObject { case insertion }
private enum Status { case success, failure, unknown }
struct PathologiesView: View {
    
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var newPathology : String = String()
    @State private var creationStatus : Status = .unknown
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea()
                List {
                    // Insertion field
                    Section {
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "microbe.fill")
                            TextField("Pathology Name", text: $newPathology)
                                .accessibilityIdentifier("PathologyField")
                                .onSubmit {
                                    insertPathology()
                                    creationStatus = .unknown
                                }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .labelStyle(Cubic(glyphBackgroundColor: Color("AstroRed")))
                    // Pathologies list
                    Section {
                        ForEach(Array(pathologiesViewModel.pathologies.enumerated()), id:\.element) { index,pathology in
                            Label(pathology.name.capitalized, systemImage: "microbe.fill")
                                .labelStyle(Cubic())
                                .swipeActions {
                                    Button(
                                        role: .destructive,
                                        action: { pathologiesViewModel.removePathology(at: index) },
                                        label: { Image(systemName: "trash.fill") }
                                    )
                                    .accessibilityIdentifier("DeleteButton")
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .accessibility(identifier: "PathologiesList")
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
        }
        // NavigationStack configuration
        .navigationBarTitle("Pathologies")
        .navigationBarTitleDisplayMode(.inline)
        // Fetches the pathologies list
        .onAppear(perform: { pathologiesViewModel.fetchPathologies() })
        // Avoids list glitch when the keyboard appears
        .ignoresSafeArea(.keyboard)
        // Display a specific alert regarding the pathology creation process
        .SPIndicator(
            isPresent: Binding.constant(creationStatus == .success),
            title: "Success",
            message: "Pathology Created",
            duration: 3.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "checkmark.circle.fill")!.withTintColor(UIColor(Color(.systemGreen)), renderingMode: .alwaysOriginal)),
            haptic: .warning,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
        .SPIndicator(
            isPresent: Binding.constant(creationStatus == .failure),
            title: "Error",
            message: "Bad Pathology",
            duration: 3.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
            haptic: .warning,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
    }
    
    // Creates a new pathology in the list
    private func insertPathology() {
        // Checks if the user has been typed at least on letter and if the inserted pathology already exists
        guard newPathology.count > 0,
              !pathologiesViewModel.pathologies.contains(where: { $0.name == newPathology })
        else {
            // Displays a warning mark if something went wrong
            withAnimation{ creationStatus = .failure }
            return
        }
        withAnimation{ pathologiesViewModel.addPathology(pathology: newPathology) }
        newPathology = String()
        withAnimation { creationStatus = .success }
    }
}
