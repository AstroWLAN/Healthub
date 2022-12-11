import SwiftUI
import AlertToast
enum Examination : String, CaseIterable {
    case routine, vaccination, sport, specialist, certificate, other
    
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

struct TicketCreationView: View {
    
    @State private var examinationGlyph : String?
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // This array should contain all the possible time slots for the selected day
    //@State private var timeSlots : [String] = ["16 : 15","16 : 30","16 : 45","17 : 00"]

    // These variables contains the user choices
    @State private var ticketExamination : Examination?
    @State private var ticketDoctor : Doctor!
    @State private var ticketDate : Date = Date()
    @State private var ticketSlot : String = ""
    
    @State private var displayExaminations : Bool = false
    @State private var displayDoctors : Bool = false

    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Information")){
                    HStack{
                        Button(action: { displayExaminations = true },
                               label:  { Label(ticketExamination?.rawValue.capitalized ?? "Examinations",systemImage: examinationGlyph ?? "staroflife.fill" )
                                         //   labelStyle(SettingLabelStyle())
                            
                        }
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17,weight: .medium))
                            .foregroundColor(Color(.systemGray3))
                    }
                    .sheet(isPresented: $displayExaminations, onDismiss: {
                        if let exam = ticketExamination?.rawValue{
                            self.ticketViewModel.fetchDoctorsByExamName(exam_name: exam);
                            
                        }
                    }){
                        ExaminationsView(selectedExam: $ticketExamination, examGlyph: $examinationGlyph)
                            .presentationDetents([.medium])
                    }
                    HStack{
                        Button(action: { displayDoctors = true },
                               label:  { Label(ticketDoctor?.name ?? "Doctor",systemImage: "stethoscope" )
                            //.labelStyle(SettingLabelStyle())
                            
                        }
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17,weight: .medium))
                            .foregroundColor(Color(.systemGray3))
                    }
                    .sheet(isPresented: $displayDoctors, onDismiss: {
                        //if let doctor = ticketDoctor{
                        //    self.ticketViewModel.fetchAvailableDates(doctor_id: doctor.id)
                       // }
                    }){
                        DoctorsView(selectedDoctor: $ticketDoctor)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Section(header: Text("Date")){
                    DatePicker(selection: $ticketDate, displayedComponents: [.date]){
                        Label("Exam Date", systemImage: "calendar").labelStyle(SettingLabelStyle())
                    }
                }.onChange(of: ticketDate, perform: { value in
                    if let exam = ticketExamination?.index{
                        if let doctor = ticketDoctor {
                            ticketViewModel.fetchSlots(doctor_id: doctor.id, examinationType_id: exam + 1, date: value)
                        }
                    }
                })
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Section(header: Text("Time")){
                    Label("Exam Time Slot", systemImage: "timer")//.labelStyle(SettingLabelStyle())
                    Picker("", selection: $ticketSlot){
                        Text("")
                        ForEach(ticketViewModel.slots, id: \.self){slot in
                            Text(slot).tag(ticketViewModel.slots.firstIndex(of: slot)!)
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
        .toolbar{
            if(ticketViewModel.completed == false  && ticketViewModel.hasError == false){
                Button(action: {
                if let exam = ticketExamination?.index{
                    if let doctor = ticketDoctor {
                        if ticketSlot != ""{
                            ticketViewModel.addReservation(date: ticketDate, starting_time: ticketSlot, doctor_id: doctor.id, examinationType_id: exam + 1)
                           
                        }
                    }
                }
                
            }, label: { Image(systemName: "checkmark") })
                .disabled(ticketSlot == "" || ticketDoctor == nil || ticketExamination == nil)
            }else{
                ProgressView().progressViewStyle(.circular)
                    .onDisappear(perform: {
                        self.mode.wrappedValue.dismiss()
                    })
            }
            
            
       
        }
        
       .toast(isPresenting: $ticketViewModel.hasError, alert: {
            AlertToast(type: .error(Color("HealthGray3")),title: "An error occured")
        })
        .toast(isPresenting: $ticketViewModel.completed, alert: {
             AlertToast(type: .complete(Color("HealthGray3")),title: "Reservation Created")
        })
        
        
    }
}

struct TicketCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TicketCreationView()
    }
}
