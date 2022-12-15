import SwiftUI
import TextView
import AlertToast

private enum FocusableObject { case name, duration, doctor, notes }

struct Prescription: View {
    @FocusState private var objectFocused: FocusableObject?
    @State private var displayDrugsDatabase : Bool = false
    @State private var displayNotes : Bool = false
    @State private var prescriptionDrugs : [Drug] = []
    @State private var prescriptionName : String = String()
    //@State private var prescriptionDoctor : String = String()
    @State private var prescriptionDuration : String = String()
    @State private var prescriptionNotes : String = String()
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
                                .focused($objectFocused, equals: .name)
                        }
                        /*HStack(spacing: 0) {
                            Label(String(), systemImage: "stethoscope")
                            TextField("Doctor", text: $prescriptionDoctor)
                                .focused($objectFocused, equals: .doctor)
                        }*/
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "timer")
                            TextField("Duration", text: $prescriptionDuration)
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
                            })
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
                            })
                        if !prescriptionDrugs.isEmpty {
                            // Appends drugs used in the prescription
                        }
                    }
                    .buttonStyle(.borderless)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowSeparator(.hidden)
                    .sheet(isPresented: $displayDrugsDatabase) {
                        DrugsDatabase( drugs: $prescriptionDrugs)
                            .presentationDetents([.large])
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
                        .disabled(
                            prescriptionDrugs.isEmpty     ||
                            prescriptionName.isEmpty      ||
                            //prescriptionDoctor.isEmpty    ||
                            prescriptionDuration.isEmpty
                        )
                    }else{
                        ProgressView().progressViewStyle(.circular)
                            .onDisappear(perform: {
                                self.mode.wrappedValue.dismiss()
                            })
                    }
                }
            }
        }
        .toast(isPresenting: $therapyViewModel.hasError, alert: {
            AlertToast(type: .error(Color("HealthGray3")),title: "An error occured")
        })
        .toast(isPresenting: $therapyViewModel.completedCreation, alert: {
             AlertToast(type: .complete(Color("HealthGray3")),title: "Reservation Created")
        })
    }
}

struct Prescription_Previews: PreviewProvider {
    static var previews: some View {
        Prescription()
    }
}
