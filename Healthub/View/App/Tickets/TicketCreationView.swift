import SwiftUI

enum Examination : String, CaseIterable {
    case routine, vaccination, sport, specialist, certificate, other
}

struct TicketCreationView: View {
    
    @State private var examinationGlyph : String?
    
    // This array should contain all the possible time slots for the selected day
    @State private var timeSlots : [String] = ["16 : 15","16 : 30","16 : 45","17 : 00"]

    // These variables contains the user choices
    @State private var ticketExamination : Examination?
    @State private var ticketDoctor : String?
    @State private var ticketDate : Date = Date()
    @State private var ticketSlot : String?
    
    @State private var displayExaminations : Bool = false
    @State private var displayDoctors : Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Information")){
                    HStack{
                        Button(action: { displayExaminations = true },
                               label:  { Label(ticketExamination?.rawValue.capitalized ?? "Examinations",systemImage: examinationGlyph ?? "staroflife.fill" )
                                            .labelStyle(SettingLabelStyle()) }
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17,weight: .medium))
                            .foregroundColor(Color(.systemGray3))
                    }
                    .sheet(isPresented: $displayExaminations){
                        ExaminationsView(selectedExam: $ticketExamination, examGlyph: $examinationGlyph)
                            .presentationDetents([.medium])
                    }
                    HStack{
                        Button(action: { displayDoctors = true },
                               label:  { Label(ticketDoctor ?? "Doctor",systemImage: "stethoscope" )
                                            .labelStyle(SettingLabelStyle()) }
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17,weight: .medium))
                            .foregroundColor(Color(.systemGray3))
                    }
                    .sheet(isPresented: $displayDoctors){
                        DoctorsView(selectedDoctor: $ticketDoctor)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Section(header: Text("Date")){
                    DatePicker(selection: $ticketDate, displayedComponents: [.date]){
                        Label("Exam Date", systemImage: "calendar").labelStyle(SettingLabelStyle())
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Section(header: Text("Time")){
                    Label("Exam Time Slot", systemImage: "timer").labelStyle(SettingLabelStyle())
                    Picker("", selection: $ticketSlot){
                        ForEach(timeSlots, id: \.self){ slot in
                            Text("\(slot)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    .frame(height: 100)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
            
        }
        .navigationTitle("Creation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{ Button(action: { /* Backend sync */ }, label: { Image(systemName: "checkmark") })
        }
    }
}

struct TicketCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TicketCreationView()
    }
}
