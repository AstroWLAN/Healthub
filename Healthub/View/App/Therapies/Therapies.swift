import SwiftUI
import TextView
import AlertToast

struct TherapiesView: View {
    
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    
    @State private var displayTherapySheet : Bool = false
    @State private var displayCreation: Bool = false
    
    @State private var detectedInteractions : Bool = false
    @State private var selectedTherapy : Therapy?
    
    var body: some View {
        NavigationStack {
            
            Group {
                if therapyViewModel.isLoadingTherapies == false {
                    List {
                        if detectedInteractions {
                            Section(header: Text(String())){
                                Label("Interactions Detected", systemImage: "exclamationmark.shield.fill")
                                    .labelStyle(Cubic(glyphBackgroundColor: .white, glyphColor: Color("AstroRed"), textColor: .white))
                                    .font(.system(size: 17, weight: .medium))
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
                            Section {
                                ForEach(Array(therapyViewModel.therapies.enumerated()), id: \.element) { index,therapy in
                                    Button(
                                        action: {
                                            selectedTherapy = therapy
                                            displayTherapySheet = true
                                        },
                                        label:  {
                                            HStack {
                                                Label(therapy.name.capitalized, systemImage: "cross.vial.fill")
                                                Spacer()
                                                Image(systemName: "circle.fill")
                                                    .foregroundColor(Color("AstroRed"))
                                                    .font(.system(size: 10))
                                                    .opacity(therapy.interactions.isEmpty ? 0 : 1)
                                            }
                                        }
                                    )
                                    .onAppear(perform: { if !therapy.interactions.isEmpty { detectedInteractions = true }})
                                    .swipeActions {
                                        Button(
                                            role: .destructive,
                                            action: { /* Remove therapy */ },
                                            label: { Image(systemName: "trash.fill") })
                                    }
                                }
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
        .tint(Color(.systemPink))
        .onAppear(perform:{therapyViewModel.fetchTherapies(force_reload: false)})
    }
}

struct TherapiesView_Previews: PreviewProvider {
    static var previews: some View {
        TherapiesView()
    }
}
