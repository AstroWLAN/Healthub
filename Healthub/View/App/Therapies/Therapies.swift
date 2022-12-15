import SwiftUI
import TextView

struct TherapySheet : View {
    
    @Binding var therapy : Therapy?
    
    var body : some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Prescription")
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 0))
                List {
                    if !therapy!.interactions.isEmpty {
                        Section  {
                            ForEach(therapy!.interactions, id: \.self) { interaction in
                                Label(interaction, systemImage: "exclamationmark.shield.fill")
                            }
                        }
                        .labelStyle(Cubic(glyphBackgroundColor: .white, glyphColor: Color("AstroRed"), textColor: .white))
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .listRowSeparatorTint(Color("AstroRed"))
                        .listRowBackground(Color("AstroRed"))
                    }
                    Section(header: Text("Generalities")) {
                        Label(therapy!.name, systemImage: "cross.vial.fill")
                        Label(therapy!.duration, systemImage: "timer")
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    /*
                     Section(header: Text("Drugs")) {
                     ForEach(therapy!.drugs, id: \.self) { drug in
                     Label(drug.name, systemImage: "pill.fill")
                     }
                     }
                     .listRowSeparator(.hidden)
                     .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                     */
                    Text(therapy!.notes)
                        .foregroundColor(Color(.systemGray))
                        .listRowBackground(Color(.systemGray5))
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .labelStyle(Cubic())
                .scrollIndicators(.hidden)
            }
        }
    }
}


struct TherapiesView: View {
    
    @State private var displayTherapySheet : Bool = false
    @State private var detectedInteractions : Bool = false
    @State private var selectedTherapy : Therapy?
    
    // Sample therapies
    @State private var userTherapies : [Therapy] = [
        Therapy(id: 0, name: "Infezione Fungina", duration: "Lifetime",
                notes: "Una pastiglia al mattino e una alla sera",
            interactions: []),
    Therapy(id: 1, name: "Asthma", duration: "3 Days",
            notes: "Un puff mattina e sera\nSciacquare la bocca con abbondante acqua dopo l'assunzione",
            interactions: []),
    Therapy(id: 2, name: "COVID-19", duration: "1 Week",
            notes: "3 pastiglie mattina e sera",
            interactions: ["Azitromicina"])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                if detectedInteractions {
                    Section(header: Text(String())){
                        Label("Interactions Detected", systemImage: "exclamationmark.shield.fill")
                            .labelStyle(Cubic(
                                glyphBackgroundColor: .white,
                                glyphColor: Color("AstroRed"),
                                textColor: .white
                            ))
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowBackground(Color("AstroRed"))
                }
                if userTherapies.isEmpty {
                    // Display Placeholder
                }
                else {
                    Section {
                        ForEach(userTherapies, id: \.self) { therapy in
                            Button(
                                action: {
                                    selectedTherapy = therapy
                                    displayTherapySheet = true
                                },
                                label:  {
                                    HStack {
                                        Label(therapy.name, systemImage: "cross.vial.fill")
                                        Spacer()
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(Color("AstroRed"))
                                            .font(.system(size: 10))
                                            .opacity(therapy.interactions.isEmpty ? 0 : 1)
                                    }
                                }
                            )
                            .onAppear(perform: { if !therapy.interactions.isEmpty { detectedInteractions = true }})
                        }
                    }
                    .labelStyle(Cubic())
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .sheet(isPresented: $displayTherapySheet) {
                        TherapySheet(therapy: $selectedTherapy)
                            .presentationDetents([.large])
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
    }
}

struct TherapiesView_Previews: PreviewProvider {
    static var previews: some View {
        TherapiesView()
    }
}
