import SwiftUI
import AlertToast

enum Examination : String, CaseIterable {
    case routine, vaccination, sport, specialist, certificate, other
    
}


struct BookingView: View {
    
    @EnvironmentObject private var ticketViewModel : TicketViewModel
    @State private var displayExaminationSheet : Bool = false
    @State private var displayDoctorSheet : Bool = false
    @State private var displayDateSheet : Bool = false
    @State private var displayTimeSheet : Bool = false
    @State private var selectedExamination : Examination?
    @State private var selectedExaminationGlyph : String?
    @State private var selectedDoctor : Doctor?
    @State private var selectedDate : Date = Date()
    @State private var selectedTimeSlot : String?
    
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
                    .sheet(isPresented: $displayExaminationSheet) {
                        ExaminationsSheet(selectedExamination: $selectedExamination, selectedExaminationGlyph: $selectedExaminationGlyph)
                            .presentationDetents([.height(360)])
                    }
                    HStack {
                        Button(
                            action: { displayDoctorSheet = true },
                            label: {
                                HStack {
                                    Label(selectedDoctor?.name.capitalized ?? "Doctor",
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
                                    Label(selectedDate.formatted(.dateTime.day().month(.wide)) + " " + selectedDate.formatted(.dateTime.year()),
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
                                    Label(selectedTimeSlot ?? "Time",
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
                        /*
                        SlotPicker(examinationTimeSlot: $selectedTimeSlot)
                            .presentationDetents([.height(200)])
                         */
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
            .labelStyle(Cubic())
            .navigationTitle("Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(
                    action: {
                        /* Sync with backend */
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
                .disabled(selectedExamination == nil || selectedDoctor == nil || selectedDate == Date() || selectedTimeSlot == nil)
            }
        }
    }
}
