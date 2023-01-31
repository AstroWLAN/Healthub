import SwiftUI
import SPIndicator

struct TherapiesView: View {
    
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    
    @State private var displayTherapySheet : Bool = false
    @State private var displayCreation: Bool = false
    
    @State private var notInteractions : Bool = true
    @State private var selectedTherapy : Therapy?
    
    @State private var prescriptionCreated : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea()
                if therapyViewModel.isLoadingTherapies == false {
                    if therapyViewModel.therapies.isEmpty {
                        VStack(spacing: 0) {
                            Image("TherapiesPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            Capsule()
                                .frame(width: 80, height: 30)
                                .foregroundColor(Color(.systemGray5))
                                .overlay(
                                    Text("Empty")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray))
                                )
                        }
                        .padding(.bottom, 40)
                    }
                    else {
                        List {
                            // Interactions alert
                            if notInteractions == false {
                                Section(header: Text(String())){
                                    Label("Interactions Detected", systemImage: "exclamationmark.shield.fill")
                                        .labelStyle(Cubic(glyphBackgroundColor: .white, glyphColor: Color("AstroRed"), textColor: .white))
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .listRowBackground(Color("AstroRed"))
                            }
                            // Therapies list
                            Section(header: Text("Prescriptions")) {
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
                                            label: { Image(systemName: "trash.fill") }
                                        )
                                        .accessibilityIdentifier("DeleteTherapyButton")
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
                        .accessibilityIdentifier("TherapiesList")
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.hidden)
                        .refreshable(action: { therapyViewModel.fetchTherapies(force_reload: false) })
                    }
                }
                // Loading therapies placeholder
                else {
                    VStack(spacing:0){
                        Spacer()
                        VStack(spacing:0) {
                            ProgressView().progressViewStyle(.circular)
                                .padding(.bottom, 10)
                                .tint(Color(.systemGray))
                            Text("Loading Therapies")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Therapies")
            .toolbar{
                NavigationLink(destination: Prescription(prescriptionSuccess: $prescriptionCreated)) {
                    ZStack {
                        Circle()
                            .frame(height: 28)
                            .opacity(0.2)
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .accessibilityIdentifier("AddPrescriptionButton")
            }
        }
        .tint(Color("AstroRed"))
        .onChange(of: prescriptionCreated, perform: {_ in
            prescriptionCreated = false
        })
        .SPIndicator(
            isPresent: $prescriptionCreated,
            title: "Success",
            message: "Prescription Created",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage(systemName: "checkmark.circle.fill")!.withTintColor(UIColor(Color(.systemGreen)), renderingMode: .alwaysOriginal)),
            haptic: .success,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)))
    }
}
