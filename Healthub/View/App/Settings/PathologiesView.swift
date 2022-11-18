import SwiftUI
struct PathologiesView: View {
    
    @State private var isCreatingPathology : Bool = false
    
    /// **TEMPORARY VARIABLES**
    // Replace them with the therapy object from the data model
    @EnvironmentObject private var pathologiesViewModel: PathologiesViewModel
    @State private var newPathology : String = ""
    @State private var userPathologies : [Pathology] = []
    @State private var badPathology : Bool = false
    
    func addPathology() {
        // Checks that the inserted pathology name has :
        /// - At least one letter
        /// - No duplicates
        guard newPathology.count > 0, !userPathologies.contains(where: { $0.name == newPathology })
        else {
            withAnimation{ badPathology = true }
            return
        }
        withAnimation{ pathologiesViewModel.addPathology(pathology: newPathology) }
        newPathology = String()
        withAnimation {
            badPathology = false
            isCreatingPathology = false
        }
    }
    
    var body: some View {
        
        List{
            /// ** Pathology Creation Field **
            // Adds a new element to the pathologies array
            Section{
                RecordTextfield(textVariable: $newPathology,
                                glyph: "microbe.fill",
                                glyphColor: Color(.white),
                                glyphBackground: Color(.systemPink),
                                placeholder: "Pathology",
                                textfieldType: .pathology,
                                badInput: badPathology,
                                measure: "")
                .onSubmit {
                    addPathology()
                    pathologiesViewModel.fetchPatologies()
                }
            }
            .isVisible(isCreatingPathology)
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            // Displays the user pathologies
            Section{
                ForEach(pathologiesViewModel.pathologies, id: \.id) { pathology in
                    Label(pathology.name, systemImage: "microbe.fill").labelStyle(SettingLabelStyle())
                }.onDelete(perform: pathologiesViewModel.removePathology)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        }
        .onAppear(perform:pathologiesViewModel.fetchPatologies)
        .navigationBarTitle("Pathologies", displayMode: .inline)
        .toolbar{
            Button( action: { withAnimation{ isCreatingPathology=true }},
                    label:  { Image(systemName: "plus")
                                .font(.system(size: 17, weight: .medium)) })
            .disabled(isCreatingPathology)
        }
    }
}

struct PathologiesView_Previews: PreviewProvider {
    static var previews: some View {
        PathologiesView()
    }
}
