import SwiftUI
import SPIndicator

struct BookingView: View {
    
    @Environment(\.dismiss) var dismissView
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
            // TICKET BOOKING FORM
            List {
                // Section : Examination and Doctor
                Section {
                    // Examination
                    HStack {
                        Button(
                            action: { displayExaminationSheet = true },
                            label: {
                                HStack {
                                    Label(selectedExamination?.rawValue.capitalized ?? "Examination", systemImage: selectedExaminationGlyph ?? "staroflife.fill")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                        .accessibilityIdentifier("ExaminationsButton")
                    }
                    .labelStyle(Cubic())
                    .sheet(isPresented: $displayExaminationSheet, onDismiss: {
                        // Fetch doctors who provide the selected examination
                        if let exam = selectedExamination?.rawValue { self.ticketViewModel.fetchDoctorsByExamName(exam_name: exam) }}) {
                            // Displays a sheet with all the available examination types
                            ExaminationsSheet(selectedExamination: $selectedExamination, selectedExaminationGlyph: $selectedExaminationGlyph)
                                .presentationDetents([.height(320)])
                    }
                    // Doctors
                    HStack {
                        Button(
                            action: { displayDoctorSheet = true },
                            label: {
                                HStack {
                                    Label(selectedDoctor?.name!.capitalized ?? "Doctor", systemImage: "stethoscope")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                        .accessibilityIdentifier("DoctorsButton")
                    }
                    .disabled(selectedExamination == nil ? true : false)
                    .opacity(selectedExamination == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayDoctorSheet) {
                        // Displays a sheet with all the available doctors for the selected examination
                        DoctorsDatabaseView(selectedDoctor: $selectedDoctor, ticketsView: true)
                            .presentationDetents([.large])
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                // Section : Date and Time
                Section(header: Text("Date")) {
                    // Date
                    HStack {
                        Button(
                            action: { displayDateSheet = true },
                            label: {
                                HStack {
                                    Label(selectedDate.formatted(.dateTime.day().month(.wide)).capitalized + " " + selectedDate.formatted(.dateTime.year()), systemImage: "calendar")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                        .accessibilityIdentifier("DateButton")
                    }
                    .disabled(selectedDoctor == nil ? true : false)
                    .opacity(selectedDoctor == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayDateSheet) {
                        // Displays a picker with all the available dates
                        DayPicker(examinationDate: $selectedDate)
                            .presentationDetents([.height(200)])
                        
                    }
                    // Time
                    HStack {
                        Button(
                            action: { displayTimeSheet = true },
                            label: {
                                HStack {
                                    Label(selectedTimeSlot == "" ? "Time": selectedTimeSlot, systemImage: "timer")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray4))
                                }
                            })
                        .accessibilityIdentifier("TimeButton")
                    }
                    .disabled(selectedDoctor == nil ? true : false)
                    .opacity(selectedDoctor == nil ? 0.4 : 1)
                    .sheet(isPresented: $displayTimeSheet) {
                        // Displays a picker with all the available time slots
                        SlotPicker(examinationTimeSlot: $selectedTimeSlot)
                            .presentationDetents([.height(200)])
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .onChange(of: selectedDate, perform: { value in
                    // Fetches the available time slots for the new selected date
                    if let exam = selectedExamination?.index {
                        if let doctor = selectedDoctor { ticketViewModel.fetchSlots(doctor_id: Int(doctor.id), examinationType_id: exam + 1, date: value) }
                    }
                    // Invalidates the time slot field
                    selectedTimeSlot = String()
                })
            }
            .accessibilityIdentifier("BookingList")
            .labelStyle(Cubic())
            .onChange(of: selectedExamination, perform: { _ in
                // Invalidates all the fields if the selected examination changes
                selectedDoctor = nil
                selectedDate = Date()
                selectedTimeSlot = String()
            })
            .onChange(of: selectedDoctor, perform: { _ in
                // Invalidates the date and time fields if the selected doctor changes
                selectedDate = Date()
                selectedTimeSlot = String()
            })
            .navigationTitle("Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if ticketViewModel.sent == false{
                    // Booking button
                    Button(
                        action: { ticketViewModel.addReservation(date: selectedDate, starting_time: selectedTimeSlot, doctor_id: Int(selectedDoctor!.id), examinationType_id: (selectedExamination?.index ?? 0) + 1) },
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
                    .accessibilityIdentifier("ConfirmButton")
                    .disabled(selectedExamination == nil || selectedDoctor == nil || selectedTimeSlot == "")
                }
                else {
                    // Creation in progress
                    if(ticketViewModel.completed == false && ticketViewModel.hasError == false) {
                        ProgressView().progressViewStyle(.circular)
                            .tint(Color(.systemGray))
                            .isVisible(ticketViewModel.completed == false && ticketViewModel.hasError == false)
                            .onDisappear(perform: { dismissView() })
                    }
                }
            }
        }
    }
}
