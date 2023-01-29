import SwiftUI

struct ExamGlyph {
    static let examGlyphs : [ String : String ] = [ "routine" : "figure.arms.open", "vaccination" : "cross.vial.fill", "sport" : "figure.run",
                                                    "specialist" : "brain.head.profile", "certificate" : "heart.text.square.fill", "other" : "magnifyingglass" ]
    
    func generateGlyph(name : String) -> String {
        return ExamGlyph.examGlyphs[name] ?? "staroflife.fill"
    }
}

struct DrugAnalyzer {
    enum DrugComponent { case name, packaging }
    
    func decomposeDrugName(input : String, component : DrugComponent) -> String {
        let drugNameComponents = input.components(separatedBy: "*")
        switch component {
        case .name:
            return drugNameComponents[0]
        case .packaging:
            return drugNameComponents[1]
        }
    }
}

struct GenderSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var userGender : Gender
    
    var body : some View {
        Picker(String(), selection: $userGender) {
            ForEach(Gender.allCases, id:\.self) { gender in
                Text("\(gender.rawValue.capitalized)")
            }
        }
        .pickerStyle(WheelPickerStyle())
        .accessibilityIdentifier("Shared_GenderPicker")
        .onTapGesture { dismissView() }
    }
}

struct HeightSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var userHeight : String
    
    var body : some View {
        VStack {
            Picker(String(), selection: $userHeight) {
                ForEach((120...201).map(String.init), id:\.self) { height in
                    Text(height+" cm")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .accessibilityIdentifier("Shared_HeightPicker")
            .onTapGesture { dismissView() }
        }
    }
}

struct WeightSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var userWeight : String
    
    var body : some View {
        Picker(String(), selection: $userWeight) {
            ForEach((40...181).map(String.init), id:\.self) { weight in
                Text(weight+" kg")
            }
        }
        .pickerStyle(WheelPickerStyle())
        .accessibilityIdentifier("Shared_WeightPicker")
        .onTapGesture { dismissView() }
    }
}

struct BirthdateSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var birthdate : Date
    
    var body : some View {
        DatePicker(String(), selection: $birthdate,in: ...Date(), displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .accessibilityIdentifier("Shared_BirthdayPicker")
            .onTapGesture { dismissView() }
    }
}

struct DayPicker : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var examinationDate : Date
    //.addingTimeInterval(86400)...
    var body : some View {
        DatePicker(String(), selection: $examinationDate, in: Date.now..., displayedComponents: .date)
            .accessibilityIdentifier("DayPicker")
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .onTapGesture { dismissView() }
    }
}

struct SlotPicker : View {
    
    @Environment(\.dismiss) var dismissView
    @EnvironmentObject private var ticketViewModel : TicketViewModel
    @Binding var examinationTimeSlot : String
    
    var body : some View {
        // Placeholder for the empty slots list
        if ticketViewModel.slots.isEmpty {
            VStack {
                Text("No Slots Available")
                    .font(.system(size: 17,weight: .semibold))
                    .foregroundColor(Color(.systemGray))
                Text("Select Another Date")
                    .font(.system(size: 15))
                    .foregroundColor(Color(.systemGray2))
            }
        }
        // Slot picker
        else {
            Picker(String(), selection: $examinationTimeSlot){
                ForEach(ticketViewModel.slots, id: \.self) { slot in
                    Text(String(slot))
                }
            }
            .accessibilityIdentifier("TimePicker")
            .pickerStyle(WheelPickerStyle())
            .onTapGesture { dismissView() }
            .onAppear(perform: { examinationTimeSlot = ticketViewModel.slots[0] })
        }
    }
}
