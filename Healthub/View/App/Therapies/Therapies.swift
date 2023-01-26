import SwiftUI
import TextView
import AlertToast

struct TherapiesView: View {
    
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    
    @State private var displayTherapySheet : Bool = false
    @State private var displayCreation: Bool = false
    
    @State private var notInteractions : Bool = true
    @State private var selectedTherapy : Therapy?
    
    var body: some View {
        NavigationStack {
            
            Group {
                if therapyViewModel.isLoadingTherapies == false {
                    List {
                        if notInteractions == false {
                            Section(header: Text(String())){
                                Label("Interactions Detected", systemImage: "exclamationmark.shield.fill")
                                    .labelStyle(Cubic(glyphBackgroundColor: .white, glyphColor: Color("AstroRed"), textColor: .white))
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .listRowBackground(Color("AstroRed"))
                        }
                        if therapyViewModel.therapies.isEmpty {
                            Image("TherapiesPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .padding(.bottom, 80)
                        }
                        else {
                            Section(header: Text("Therapies")) {
                                ForEach(Array(therapyViewModel.therapies.enumerated()), id: \.element) { index,therapy in
                                    Button(
                                        action: {
                                            selectedTherapy = therapy
                                            displayTherapySheet = true
                                        },
                                        label:  {
                                            HStack(spacing: 8) {
                                                Label(therapy.name.capitalized, systemImage: "cross.vial.fill")
                                                Spacer()
                                                Image(systemName: "circle.fill")
                                                    .foregroundColor(Color("AstroRed"))
                                                    .font(.system(size: 10))
                                                    .opacity(therapy.interactions.isEmpty ? 0 : 1)
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundColor(Color(.systemGray4))
                                            }
                                        }
                                    )
                                    .onAppear(perform: {
                                        notInteractions = notInteractions && therapy.interactions.isEmpty
                                        })
                                    .swipeActions {
                                        Button(
                                            role: .destructive,
                                            action: {
                                                therapyViewModel.deleteTherapy(therapy_id: Int(therapy.id))
                                                notInteractions = true
                                            },
                                            label: { Image(systemName: "trash.fill") })
                                    }
                                }
                            }
                            .refreshable{
                                // Refresh therapies list
                                therapyViewModel.fetchTherapies(force_reload: true)
                            }
                            .labelStyle(Cubic())
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 16))
                            .sheet(isPresented: $displayTherapySheet) {
                                TherapySheetView(therapy: $selectedTherapy)
                                    .presentationDetents([.large])
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                else {
                    VStack {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                            .tint(Color(.systemGray))
                        Text("Loading Therapies")
                            .font(.system(size: 15,weight: .medium))
                    }
                }
            }
            .navigationTitle("Therapies")
            .toolbar{
                NavigationLink(destination: Prescription()) {
                    ZStack {
                        Circle()
                            .frame(height: 28)
                            .opacity(0.2)
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .medium))
                    }
                }
            }
        }
        .tint(Color("AstroRed"))
        .onAppear(perform:{therapyViewModel.fetchTherapies(force_reload: false)})
    }
}

struct TherapiesView_Previews: PreviewProvider {
    static var previews: some View {
        TherapiesView()
    }
}
