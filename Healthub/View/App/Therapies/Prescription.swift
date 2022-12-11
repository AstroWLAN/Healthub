import SwiftUI

private enum FocusableObject {
    case name, duration, doctor, notes
}

struct Drug { /* Drug Object */ }

struct Prescription: View {
    
    @FocusState private var objectFocused: FocusableObject?
    @State private var displayDrugsDatabase : Bool = false
    @State private var prescriptionDrugs : [Drug] = []
    @State private var prescriptionName : String = String()
    @State private var prescriptionDuration : String = String()
    @State private var prescriptionDoctor : String = String()
    @State private var prescriptionNotes : String = String()
    @State private var prescriptionPlaceholder : String = "Notes"
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
                .onTapGesture(perform: {
                    objectFocused = nil
                })
            NavigationStack {
                List {
                    Button(
                        action: { displayDrugsDatabase = true },
                        label:  {
                            HStack {
                                Label("Drugs Database", systemImage: "cloud.fill")
                                    .labelStyle(Cubic())
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 15,weight: .semibold))
                                    .foregroundColor(Color(.systemGray4))
                            }
                        }
                    )
                    .buttonStyle(.borderless)
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 16))
                    Section {
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "cross.vial.fill")
                                .labelStyle(Cubic())
                            TextField("Name", text: $prescriptionName)
                                .autocorrectionDisabled(true)
                                .focused($objectFocused, equals: .name)
                        }
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "calendar")
                                .labelStyle(Cubic())
                            TextField("Duration", text: $prescriptionDuration)
                                .autocorrectionDisabled(true)
                                .focused($objectFocused, equals: .duration)
                        }
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "stethoscope")
                                .labelStyle(Cubic())
                            TextField("Doctor", text: $prescriptionDoctor)
                                .autocorrectionDisabled(true)
                                .focused($objectFocused, equals: .doctor)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    Section( footer:
                                HStack {
                        Spacer()
                        Text("\(prescriptionNotes.count) Char")
                            .bold()
                    }
                    ){
                        TextField("Notes", text: $prescriptionNotes, axis: .vertical)
                            .autocorrectionDisabled(true)
                            .lineLimit(4, reservesSpace: true)
                            .focused($objectFocused, equals: .notes)
                            .padding(.vertical, 8)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    // Displays the drugs used in the prescription
                    if !prescriptionDrugs.isEmpty {
                        Section {
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                }
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $displayDrugsDatabase) {
                    DrugsDatabase()
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.large])
                }
                .navigationTitle("Prescription")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(
                        action: { /* Sync with backend */ },
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
                }
            }
        }
    }
}

struct Prescription_Previews: PreviewProvider {
    static var previews: some View {
        Prescription()
    }
}
