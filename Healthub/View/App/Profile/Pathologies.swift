import SwiftUI
import AlertToast

struct PathologiesView: View {
    
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    @State private var newPathology : String = String()
    @State private var badPathologyName : Bool = false
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: Text("Insertion")){
                    HStack(spacing: 0) {
                        Label(String(), systemImage: "microbe.fill")
                        TextField("Pathology", text: $newPathology)
                            .textContentType(.name)
                            .keyboardType(.asciiCapable)
                            .onSubmit {
                                addPathology()
                                pathologiesViewModel.fetchPathologies()
                            }
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
                .labelStyle(Cubic(glyphBackgroundColor: Color(.systemPink)))
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                if !pathologiesViewModel.pathologies.isEmpty {
                    Section(header: Text("List")) {
                        ForEach(Array(pathologiesViewModel.pathologies.enumerated()), id: \.element) { index,pathology in
                            Label(pathology.name.capitalized, systemImage: "microbe.fill")
                                .swipeActions {
                                    Button(
                                        role: .destructive,
                                        action: {
                                            // Remove pathology method need a valid Int index (index)
                                            pathologiesViewModel.removePathology(at: index)
                                        },
                                        label: {
                                            Image(systemName: "trash.fill")
                                        })
                                }
                        }
                    }
                    .labelStyle(Cubic())
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
            }
            .navigationBarTitle("Pathologies")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(Color(.systemPink))
        .onAppear(perform: { pathologiesViewModel.fetchPathologies() })
        .toast(isPresenting: $pathologiesViewModel.isLoadingPathologies, alert:{
            AlertToast(type: .loading ,title: "Loading")
        })
    }
    private func addPathology() {
        guard newPathology.count > 0,
             !pathologiesViewModel.pathologies.contains(where: { $0.name == newPathology })
        else {
            withAnimation{ badPathologyName = true }
            return
        }
        withAnimation{ pathologiesViewModel.addPathology(pathology: newPathology) }
        newPathology = String()
        withAnimation { badPathologyName = false }
    }
}

struct PathologiesView_Previews: PreviewProvider {
    static var previews: some View {
        PathologiesView()
    }
}
