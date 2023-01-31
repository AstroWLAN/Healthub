import SwiftUI
import TextView
import SPIndicator

private enum FocusableObject { case name, duration, doctor, notes }

struct Prescription: View {
    
    @Environment(\.dismiss) var dismissView
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    
    @FocusState private var objectFocused: FocusableObject?
    @State private var displayDrugsDatabase : Bool = false
    @State private var displayNotes : Bool = false
    @State private var prescriptionDrugs : [Drug] = []
    @State private var prescriptionName : String = String()
    @State private var prescriptionDuration : String = String()
    @State private var prescriptionNotes : String = String()
    
    @Binding var prescriptionSuccess : Bool
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            NavigationStack {
                List {
                    Section {
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "cross.vial.fill")
                            TextField("Name", text: $prescriptionName)
                                .accessibilityIdentifier("TherapyNameTextfield")
                                .focused($objectFocused, equals: .name)
                        }
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "timer")
                            TextField("Duration", text: $prescriptionDuration)
                                .accessibilityIdentifier("TherapyDurationTextfield")
                                .focused($objectFocused, equals: .doctor)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .labelStyle(Cubic())
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .listRowSeparator(.hidden)
                    
                    Section {
                        Button(
                            action: { displayNotes = true },
                            label:  {
                                HStack {
                                    Label("Notes", systemImage: "loupe")
                                        .labelStyle(Cubic())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15,weight: .medium))
                                        .foregroundColor(Color(.systemGray3))
                                }
                            }
                        )
                        .accessibilityIdentifier("NotesButton")
                    }
                    .buttonStyle(.borderless)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .sheet(isPresented: $displayNotes) {
                        Notes(doctorNotes: $prescriptionNotes)
                            .presentationDetents([.large])
                    }
                    Section(header: Text("Drugs")) {
                        Button(
                            action: { displayDrugsDatabase = true },
                            label:  {
                                HStack {
                                    Label("Drugs Database", systemImage: "cloud.fill")
                                        .labelStyle(Cubic())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15,weight: .medium))
                                        .foregroundColor(Color(.systemGray3))
                                }
                            }
                        )
                        .accessibilityIdentifier("DrugsDatabase")
                    }
                    .buttonStyle(.borderless)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowSeparator(.hidden)
                    .sheet(isPresented: $displayDrugsDatabase) {
                        DrugsDatabase( drugs: $prescriptionDrugs)
                            .presentationDetents([.large])
                    }
                    if !prescriptionDrugs.isEmpty {
                        ForEach(Array(prescriptionDrugs.enumerated()), id: \.element) { index,drug in
                            HStack(alignment: .firstTextBaseline) {
                                Label(String(), systemImage: "pill.fill")
                                VStack(alignment: .leading) {
                                    Text(DrugAnalyzer().decomposeDrugName(input: drug.denomination_and_packaging, component: .name).lowercased().capitalized)
                                    Text(DrugAnalyzer().decomposeDrugName(input: drug.denomination_and_packaging, component: .packaging).lowercased().capitalized)
                                        .foregroundColor(Color(.systemGray2))
                                        .font(.system(size: 15))
                                }
                            }
                            .labelStyle(Cubic())
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .listRowSeparator(.hidden)
                    }
                }
                .navigationTitle("Prescription")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if(therapyViewModel.completedCreation == false && therapyViewModel.hasError == false){
                        Button(
                            action: {
                                /* Sync with backend */
                                therapyViewModel.createNewTherapy(drugs: prescriptionDrugs, duration: prescriptionDuration, name: prescriptionName, comment: prescriptionNotes)
                            },
                            label:  {
                                ZStack {
                                    Circle()
                                        .frame(height: 28)
                                        .opacity(0.2)
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 13, weight: .medium))
                                }
                            }
                        )
                        .accessibilityIdentifier("PrescriptionCreationButton")
                        .disabled(
                            prescriptionDrugs.isEmpty     ||
                            prescriptionName.isEmpty      ||
                            prescriptionDuration.isEmpty
                        )
                    }
                    // Creation in progress
                    else {
                        if(therapyViewModel.completedCreation == false && therapyViewModel.hasError == false){
                            ProgressView().progressViewStyle(.circular)
                                .tint(Color(.systemGray))
                                .isVisible(therapyViewModel.completedCreation == false && therapyViewModel.hasError == false)
                        }
                    }
                }
            }
        }
        .onAppear(perform: { therapyViewModel.completedCreation = false } )
        .onChange(of: therapyViewModel.completedCreation, perform: { _ in
            if therapyViewModel.completedCreation == true {
                prescriptionSuccess = true
                dismissView()
            }
        })
        .SPIndicator(
            isPresent: $therapyViewModel.hasError,
            title: "Error",
            message: "Prescription Failure",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
            haptic: .error,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)))
    }
}
