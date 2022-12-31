import SwiftUI
import AlertToast


struct BookingView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject private var ticketViewModel : TicketViewModel
    
    @State private var displayExaminationSheet : Bool = false
    @State private var displayDoctorSheet : Bool = false
    @State private var displayDateSheet : Bool = false
    @State private var displayTimeSheet : Bool = false
    
    @State private var selectedExamination : Examination?
    @State private var selectedExaminationGlyph : String?
    @State private var selectedDoctor : Doctor?
    @State private var selectedDate : Date = Date()
    @State private var selectedTimeSlot : String = String()
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    HStack {
                        Button(
                            action: { displayExaminationSheet = true },
                            label: {
                                HStack {
                                    Label(selectedExamination?.rawValue.capitalized ?? "Examination",
                                          systemImage: selectedExaminationGlyph ?? "staroflife.fill")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                    }
                    .labelStyle(Cubic())
                    .sheet(isPresented: $displayExaminationSheet, onDismiss: {
                        if let exam = selectedExamination?.rawValue{
                            self.ticketViewModel.fetchDoctorsByExamName(exam_name: exam);
                            
                        }}){
                        ExaminationsSheet(selectedExamination: $selectedExamination, selectedExaminationGlyph: $selectedExaminationGlyph)
                            .presentationDetents([.height(320)])
                    }
                    HStack {
                        Button(
                            action: { displayDoctorSheet = true },
                            label: {
                                HStack {
                                    Label(selectedDoctor?.name!.capitalized ?? "Doctor",
                                          systemImage: "stethoscope")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                    }
                    .disabled(selectedExamination == nil ? true : false)
                    .opacity(selectedExamination == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayDoctorSheet) {
                        DoctorsDatabaseView(selectedDoctor: $selectedDoctor)
                            .presentationDetents([.large])
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                Section(header: Text("Date")) {
                    HStack {
                        Button(
                            action: { displayDateSheet = true },
                            label: {
                                HStack {
                                    Label(selectedDate.formatted(.dateTime.day().month(.wide)).capitalized + " " + selectedDate.formatted(.dateTime.year()),
                                          systemImage: "calendar")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                    }
                    .disabled(selectedDoctor == nil ? true : false)
                    .opacity(selectedDoctor == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayDateSheet) {
                        DayPicker(examinationDate: $selectedDate)
                            .presentationDetents([.height(200)])
                    }
                    HStack {
                        Button(
                            action: { displayTimeSheet = true },
                            label: {
                                HStack {
                                    Label(selectedTimeSlot == "" ? "Time": selectedTimeSlot,
                                          systemImage: "timer")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                    }
                    .disabled(selectedDoctor == nil ? true : false)
                    .opacity(selectedDoctor == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayTimeSheet) {
                        SlotPicker(examinationTimeSlot: $selectedTimeSlot)
                            .presentationDetents([.height(200)])
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .onChange(of: selectedDate, perform: { value in
                    if let exam = selectedExamination?.index{
                        if let doctor = selectedDoctor {
                            ticketViewModel.fetchSlots(doctor_id: Int(doctor.id), examinationType_id: exam + 1, date: value)
                        }
                    }
                })
            }
            .labelStyle(Cubic())
            .navigationTitle("Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if ticketViewModel.sent == false{
                    Button(
                        action: {
                            /* Sync with backend */
                            ticketViewModel.addReservation(date: selectedDate, starting_time: selectedTimeSlot, doctor_id: Int(selectedDoctor!.id), examinationType_id: (selectedExamination?.index ?? 0) + 1)
                            
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
                    .disabled(selectedExamination == nil || selectedDoctor == nil || selectedTimeSlot == "")
                }else{
                    if(ticketViewModel.completed == false && ticketViewModel.hasError == false){
                        ProgressView().progressViewStyle(.circular)
                            .isVisible(ticketViewModel.completed == false && ticketViewModel.hasError == false)
                            .onDisappear(perform:{
                                self.mode.wrappedValue.dismiss()
                            })
                    }
                }
            }
        }
    }
}
